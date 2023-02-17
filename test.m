clear;clc;close all;

%init pop
max_iteration=5;
pocet_genov=10;
populacia=50;
numgen=500;
mr=0.6;
Space=ones(2,pocet_genov).*[-500;500];
alfa=0.9;
rate=0.6;
Amp=10.0*ones(1,pocet_genov);

for cnt=1:max_iteration
    pop=genrpop(populacia,Space);
    
for gen=1:numgen
    ucelova_funkcia=schwefel(pop);
    [fitgraph(cnt,gen),idx]= min(ucelova_funkcia);
    najlepsia_skupina(cnt,:)=pop(idx,:);
    
    best=selbest(pop,ucelova_funkcia,[2 2 2 2]);
    sel_0=selrand(pop,ucelova_funkcia,8);
    sel_1=selsus(pop,ucelova_funkcia,6);
    sel_2=seltourn(pop,ucelova_funkcia,populacia-size(best,1)-size(sel_0,1)-size(sel_1,1));
    
    sel_0(:)=around(sel_0,0,alfa,Space) ;
    sel_1(:)=crossov(sel_1,2,0);
    
    sel_2(:)=mutx(sel_2,rate,Space);
    best(2:end,:)=muta(best(2:end,:),rate,Amp,Space);
    
    pop(:)=[best;sel_0;sel_1;sel_2];
 
end %gen
najlepsia_hodnota(cnt)=fitgraph(cnt,end);
fprintf('\n\n%2d spustenie: vysledok optimalneho riesenia: %4.4f \ns genom: ',cnt,najlepsia_hodnota(cnt));
disp(najlepsia_skupina(cnt,:));

  if cnt==1
    hold on
end

plot(fitgraph(cnt,:));
end
hold off;

figure(2);
xlabel('generation');
ylabel('f(x_i)');
title('evolution graph');
grid on;

[~,idx]=min(najlepsia_hodnota);
fprintf('\n\n\t\nglobalne [optimalne] riesenie je: %4.4f pri genoch: \n',najlepsia_hodnota(idx));
disp(najlepsia_skupina(idx,:));