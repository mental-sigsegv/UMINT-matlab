clear;clc;close all;

tabulka = [0.04,0.07,0.11,0.06,0.05];
final_fitnes=0;
max_money = 1e7;
max_iteration=10;
pocet_genov=5;
populacia=50;
numgen=2000;
Priestor=[ 0, 0, 0, 0, 0; max_money, max_money, max_money, max_money, max_money];
alfa=0.9;
rate=0.8;
Amp=100.0*ones(1,pocet_genov);

for cnt=1:max_iteration
    Pop = genrpop(populacia, Priestor);
for gen=1:numgen
    ucelova_f=Fit(Pop,tabulka,max_money);
    fitness_graf(cnt,gen)= -1*min(ucelova_f);
    
    best=selbest(Pop,ucelova_f,[2 2]);
    best2=selbest(Pop,ucelova_f,[2 2 2 2 2]);
    sel_0=selrand(Pop,ucelova_f,10);
    sel_1=selsus(Pop,ucelova_f,8);
    
    sel_2=selbest(Pop,ucelova_f,populacia-size(best,1)-size(sel_0,1)-size(sel_1,1)-size(best2,1));
    
    sel_0(:)=around(sel_0,0,alfa,Priestor);
    sel_1(:)=crossov(sel_1,2,0);
    
    sel_2(:)=mutx(sel_2,rate,Priestor);
    best2(:)=around(best2,0,alfa,Priestor);
    best2(2:end,:)=muta(best2(2:end,:),rate,Amp,Priestor);
    best(2:end,:)=muta(best(2:end,:),rate,Amp,Priestor);
    
    Pop(:)=[best;best2;sel_0;sel_1;sel_2];
end %gen

    if final_fitnes < fitness_graf(end);
        final_fitnes = fitness_graf(end);
    end
najlepsia_skupina(cnt,:)=selbest(Pop,ucelova_f,1);
najlepsia_hodnota(cnt)=fitness_graf(end);
fprintf('\n\n%2d spustenie: vysledok optimalneho riesenia: %4.4f \ns hodnotami: ',cnt,fitness_graf(end));
disp(najlepsia_skupina(cnt,:));

if cnt==1
    hold on
end

plot(fitness_graf(cnt,:));
end
final_najlepsia_skupina=selbest(Pop,ucelova_f,1);
fprintf('\n\n\t\nglobalne [optimalne] riesenie je: %4.4f pri poradi: \n',final_fitnes);
disp(final_najlepsia_skupina);




function Fitness_f = Fit(Pop,tabulka,maxMoney)

    Fitness_f = (zeros(size(Pop,1),1));
    
    for index=1:size(Pop,1)
        
        prvok = Pop(index,:);
        stonks = 0;
        
        for fund=1:size(Pop,2)
            
            stonks = stonks + Pop(index,fund)*(1+tabulka(fund));
        end
        budget = sum(prvok);
        
        if budget>maxMoney
            
           stonks = 0;
           Fitness_f(index) =0;
           continue;
        end
        
        budgetInFonds = sum(prvok(1:2));
        
        if budgetInFonds> maxMoney/4
           stonks =  stonks- (budgetInFonds - maxMoney/4)*2;
        end
        
        if prvok(4)<prvok(5)
            stonks =  stonks- (prvok(5)-prvok(4));
        end
        
        p4 = -0.5*prvok(1)-0.5*prvok(2)+0.5*prvok(3)+0.5*prvok(4)-0.5*prvok(5);
        
        if p4 > 0
            stonks =  stonks-p4*2;
            stonks = 0;
        end
        
        Fitness_f(index) = -1*(stonks-sum(prvok));
    end
end