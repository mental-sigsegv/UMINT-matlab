clear;clc;close all;

load("CTGdata.mat");
targets = zeros(3,size(typ_ochorenia,1));

for i=1:size(typ_ochorenia,1)
    targets(typ_ochorenia(i),i)=1;
end

inputs = NDATA';
best = 0;

for i = 1 : 5

    net = patternnet(25);
    
    net.divideFcn = 'dividerand';
    net.divideParam.trainRatio = 0.6; 
    net.divideParam.valRatio = 0;
    net.divideParam.testRatio = 0.4;
    net.trainParam.goal = 1e-4;         
    net.performFcn = 'crossentropy';         
    net.trainParam.epochs = 300;        
    net.trainParam.min_grad = 1e-12;
    
    [net,tr] = train(net,inputs,targets);
    
    outputs = net(inputs);
    outputstrain = net(inputs(:,tr.trainInd));
    outputstest = net(inputs(:,tr.testInd));

    trainTargets = targets(:,tr.trainInd);
    testTargets = targets(:,tr.testInd);
    
    [ctrain,cmTrain] = confusion(trainTargets,outputstrain);
    [ctest,cmTest] = confusion(testTargets,outputstest);
    [c,cm] = confusion(targets,outputs);

    fprintf('%d.\tUspesnost [train, test, all]: \t\t%.4f  %.4f %.4f\n', i, 100*(1-ctrain),100*(1-ctest), 100*(1-c));
    fprintf('\tSenzitivita a specificita trenovacej vzorky : \t%.4f %.4f\n', cmTrain(2,2)/(cmTrain(2,2)+cmTrain(2,1)), cmTrain(1,1)/(cmTrain(1,1)+cmTrain(1,2)));
    fprintf('\tSenzitivita a specificita testovacej vzorky : \t%.4f %.4f\n', cmTest(2,2)/(cmTest(2,2)+cmTest(2,1)), cmTest(1,1)/(cmTest(1,1)+cmTest(1,2)));
    fprintf('\tSenzitivita a specificita celkovej vzorky   : \t%.4f %.4f\n\n', cm(2,2)/(cm(2,2)+cm(2,1)), cm(1,1)/(cm(1,1)+cm(1,2)));
    
    RESULTS(i,1) = 100*(1-ctrain);
    RESULTS(i,2) = 100*(1-ctest);
    RESULTS(i,3) = 100*(1-c);

     if(best < c)
        bestnet = net;
        best = c;
    end
end

RESULTS_MIN = min(RESULTS);
RESULTS_MAX = max(RESULTS);
RESULTS_MEAN = mean(RESULTS);

fprintf('Celkova uspesnost trenovacej klasifikacie [min, max, avg]: %.4f %.4f %.4f \n',RESULTS_MIN(1),RESULTS_MAX(1), RESULTS_MEAN(1));
fprintf('Celkova uspesnost testovacej klasifikacie [min, max, avg]: %.4f %.4f %.4f \n',RESULTS_MIN(2),RESULTS_MAX(2), RESULTS_MEAN(2));
fprintf('Celkova uspesnost celkovej klasifikacie   [min, max, avg]: %.4f %.4f %.4f \n',RESULTS_MIN(3),RESULTS_MAX(3), RESULTS_MEAN(3));

% 112 94 244
TEST_DATA = [[0,1199,129,129,6,4,1,34,1.70000000000000,0,12.9000000000000,0,0,0,0,118,78,196,10,0,137,136,137,6,0];
    [1816,2579,148,148,0,0,0,68,0.300000000000000,75,4.50000000000000,0,0,0,0,25,128,153,3,0,150,149,151,0,1];
    [0,709,123,123,0,0,1,67,0.600000000000000,27,12.6000000000000,0,0,0,0,110,50,160,7,0,125,123,125,2,1]]';

TEST_DATA_OUTPUT = vec2ind(bestnet(TEST_DATA));
display(TEST_DATA_OUTPUT);