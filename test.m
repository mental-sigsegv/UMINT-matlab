clear all;close all;clc;

% parametre
B=[0,0; 77,68; 12,75; 32,17; 51,64; 20,19; 72,87; 80,37; 35,82;
2,15; 18,90; 33,50; 85,52; 97,27; 37,67; 20,82; 49,0; 62,14; 7,60;
100,100]';


final_fitnes=intmax;
pocet_genov=size(B,2)-2;
final_poradie=zeros(1,pocet_genov);
velkost_populacie=50;
max_generacia=1000;
max_iteration=10;
rate=0.15;
funkcna_hodnota_populacie=zeros(1,velkost_populacie);

for cnt=1:max_iteration

    Newpop=generate_my_pop(pocet_genov,velkost_populacie);

for generacia=1:max_generacia
    
    %vyhodnetenie
    funkcna_hodnota_populacie(:)=calculate_my_pop(B,Newpop);
    [fitness_funkcia(cnt,generacia),idx]=min(funkcna_hodnota_populacie);
    najlepsia_skupina=Newpop(idx,:);

    % vyber
    best=selbest(Newpop,funkcna_hodnota_populacie,[2 2]);
    sel0=selrand(Newpop,funkcna_hodnota_populacie,8);
    sel2=selsus(Newpop,funkcna_hodnota_populacie,6);
    sel1=seltourn(Newpop,funkcna_hodnota_populacie,velkost_populacie-size(best,1)-size(sel0,1)-size(sel2,1));


    % crossing
    sel0=crosord(sel0,1);
    sel2=crosord(sel2,1);
    sel1=swappart(sel1,rate);
    sel2=swapgen(sel2,rate);
    sel1=invord(sel1,rate);
    Newpop=[best;sel0;sel1;sel2];

end
    
    figure(1);
    plot(fitness_funkcia(cnt,:));
    
    if cnt==1
        hold on
    end
    
   
    
    if final_fitnes > fitness_funkcia(cnt,end)
        final_fitnes = fitness_funkcia(cnt,end);
        final_poradie = najlepsia_skupina;
    end

    A=B;
for i=1:pocet_genov   
    A(:,i+1)=B(:,final_poradie(i));
end

fprintf('\n\n%2d spustenie: vysledok optimalneho riesenia: %4.4f \n s poradim: ',cnt,fitness_funkcia(cnt,end));
disp(najlepsia_skupina);

end

fprintf('\n\n\t\nglobalne [optimalne] riesenie je: %4.4f pri poradi: \n',final_fitnes);
disp(final_poradie);


figure(2)
plot(A(1,:),A(2,:),'x-');

function pop=generate_my_pop(num_of_genes,num_of_pop)
    pop=zeros(num_of_pop,num_of_genes);
    
    [~,pop(:)]=sort(rand(num_of_pop,num_of_genes),2);
    
    pop(:)=pop+1;
end


function dist=calculate_my_pop(points,pop)
    idx=[ones(size(pop,1),1), pop , (size(pop,2)+2)*ones(size(pop,1),1)];
    temp_x=reshape(points(1,idx),size(idx,1),size(idx,2));
    temp_y=reshape(points(2,idx),size(idx,1),size(idx,2));
    
    dist=sum(((temp_x(:,2:end)-temp_x(:,1:end-1)).^2 + (temp_y(:,2:end)-temp_y(:,1:end-1)).^2).^0.5,2);  
end