clear;clc;close all;

load("dataarytmiasrdca.mat");
target = zeros(2,size(typ_ochorenia,1));

for i=1:size(typ_ochorenia,1)
    if typ_ochorenia(i)==1
        target(typ_ochorenia(i),i)=1;
    else
        target(2,i)=1;
    end
end

inputs = NDATA';
targets = target;
ctest = 50;
i = 1;
i_max=10;


acc = zeros(i_max,3);
bestacc=0;

while(true)

    if i>i_max
        break
    end
    
    hiddenLayerSize = 20;
    
    net = patternnet(hiddenLayerSize);
    
    net.divideFcn = 'dividerand';  % Rozdelíme dáta náhodne

    % Nastavíme pomery pre rozdelenie datasetu
    net.divideParam.trainRatio = 0.6; 
    net.divideParam.valRatio = 0;
    net.divideParam.testRatio = 0.4;

    % Nastavenie parametrov
    net.trainParam.goal = 0.1;          % Sum-squared error goal.
    net.trainParam.show = 5;            % Frequency of progress displays (in epochs).
    net.trainParam.epochs = 150;        % Maximum number of epochs to train.
    net.trainParam.min_grad = 1e-4;     % ukoncovacia podmienka na min. gradient 
    
    [net,tr] = train(net,inputs,targets);
    
    outputs = net(inputs);
    outputstrain = net(inputs(:,tr.trainInd));
    outputstest = net(inputs(:,tr.testInd));
    trainTargets = targets(:,tr.trainInd);
    testTargets = targets(:,tr.testInd);
    errors = gsubtract(targets,outputs);
    performance = perform(net,targets,outputs);
    
    [ctrain,cmTrain] = confusion(trainTargets,outputstrain);
    [ctest,cmTest] = confusion(testTargets,outputstest);
    [c,cm] = confusion(targets,outputs);
    fprintf('%d.\tÚspešnosť klasifikácie(train,test,all): \t\t%.4f  %.4f %.4f\n',i,100*(1-ctrain),100*(1-ctest), 100*(1-c));
    fprintf('\tSenzitivita a Špecificita trénovacej vzorky : \t%.4f %.4f\n', cmTrain(2,2)/(cmTrain(2,2)+cmTrain(2,1)), cmTrain(1,1)/(cmTrain(1,1)+cmTrain(1,2)));
    fprintf('\tSenzitivita a Špecificita testovacej vzorky : \t%.4f %.4f\n', cmTest(2,2)/(cmTest(2,2)+cmTest(2,1)), cmTest(1,1)/(cmTest(1,1)+cmTest(1,2)));
    fprintf('\tSenzitivita a Špecificita celkovej vzorky : \t%.4f %.4f\n\n', cm(2,2)/(cm(2,2)+cm(2,1)), cm(1,1)/(cm(1,1)+cm(1,2)));
    
    M(i,1) = 100*(1-ctrain);
    M(i,2) = 100*(1-ctest);
    M(i,3) = 100*(1-c);
    i=i+1;
end
fprintf('\n');
Mmin = min(M);
Mmax = max(M);
Mmean = mean(M);
fprintf('Úspešnosť trénovacej klasifikácie(min,max,average): %.4f %.4f %.4f \n',Mmin(1),Mmax(1), Mmean(1));
fprintf('Úspešnosť testovacej klasifikácie(min,max,average): %.4f %.4f %.4f \n',Mmin(2),Mmax(2), Mmean(2));
fprintf('Úspešnosť celkovej klasifikácie(min,max,average): \t%.4f %.4f %.4f \n',Mmin(3),Mmax(3), Mmean(3));
