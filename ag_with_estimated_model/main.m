%% Script to train control parameters using GA
% Author: Leonardo B. Far�oni
% Creation: 06/03/2018
matlabrc
addpath('../multiControl/')
addpath('../multiControl/utils')
warning('off','all')

%% Algorithms to train
algorithms = { %'SOSMC Passive','Passive NMAC';
               %'SOSMC Passive with PIDD','Passive NMAC';
               %'SOSMC Passive Direct','None';
               %'Adaptive','Passive NMAC';
               %'Adaptive with PIDD','Passive NMAC';
               'Adaptive Direct','None';
               'Markovian RLQ-R Passive Modified','Passive NMAC'};
           
for it=1:length(algorithms)
    attitudeController = algorithms{it,1};
    controlAllocator = algorithms{it,2};
    attitudeReference = 'Passive NMAC';

    fullfilename = 0;

    %% Select nvars according to algorithms
        switch attitudeController
            case 'PID'
                initialPopulation = [220 220 220 40 40 40 50 50 50 10 10 10
                                     90 90 90 10 10 10 40 40 40 2 2 2];
                lb = zeros(1,12);
                ub = [500 500 500 500 500 500 500 500 500 100 100 100];
                initialPopulation = [initialPopulation [500 500 250 1000 1000 650 60 60 5; 130 130 50 200 200 200 14 14 2]];
                lb = [lb,zeros(1,9)];
                ub = [ub,1000*ones(1,9)];
                nvars = 21;
                initialPopulation = [initialPopulation,[0,0,0.5;0,0,0.5]];
                lb = [lb,0,0,0];
                ub = [ub,1,1,1];
                nvars = nvars + 3;
            case 'RLQ-R Passive'
                initialPopulation = [70 70 100 40 40 40 40 40 70 15 15 2];
                lb = zeros(1,12);
                ub = [1000 1000 1000 1000 1000 1000 1000 1000 1000 100 100 100];
                Q = [1e4, 1e4, 1e3,1e-1,1e-1,1e-1];
                P = Q;
                R = 70*[1,1,.1];
                Ef = 0.1*[2 2 1 0 0 0];
                Eg = 0.02*[1 1 1];
                H = [1 1 1 1 1 1];
                mu = 1e30;
                alpha = 1.5;
                initialPopulation = [initialPopulation,P,Q,R,Ef,Eg,H,mu,alpha];
                lb = [lb,zeros(1,30),100,1];
                ub = [ub,1e7*ones(1,15),1e3*ones(1,15),1e30,100];
                nvars = 44;
                initialPopulation = [initialPopulation,0,0,0.5];
                lb = [lb,0,0,0];
                ub = [ub,1,1,1];
                nvars = nvars + 3;
            case 'RLQ-R Passive Modified'
                initialPopulation = [70 70 60 2 2 40 25 25 30 3 3 3];
                lb = zeros(1,12);
                ub = [1000 1000 1000 1000 1000 1000 1000 1000 1000 100 100 100];
                Q = 500000*[1e1, 1e1, 1e1,1e1,1e1,1e1];
                P = Q;
                R = 0.00001*[1,1,1,1,1,1,1,1];
                Ef = 10*[2 2 1 0 0 0];
                Eg = 1000*[1 1 1 1 1 1 1 1];
                H = [1 1 1 1 1 1];
                mu = 1e20;
                alpha = 1.5;
                initialPopulation = [initialPopulation,P,Q,R,Ef,Eg,H,mu,alpha];
                lb = [lb,zeros(1,40),100,1];
                ub = [ub,1e9*ones(1,12),1e3*ones(1,8),1e5*ones(1,20),1e30,100];
                nvars = 54;
                initialPopulation = [initialPopulation,0,0,0.5];
                lb = [lb,0,0,0];
                ub = [ub,1,1,1];
                nvars = nvars + 3;
            case 'RLQ-R Passive Modified with PIDD'
                initialPopulation = [70 70 100 5 5 40 40 40 30 2 2 1];
                lb = zeros(1,12);
                ub = [1000 1000 1000 1000 1000 1000 1000 1000 1000 100 100 100];
                Q = 500000*[1e1, 1e1, 1e1, 1e1, 1e1, 1e1,1e1,1e1,1e1];
                P = Q;
                R = 0.00001*[1,1,1,1,1,1,1,1];
                H = [1 1 1 1 1 1 1 1 1];
                Ef = 10*[1 1 1 1 1 1 0 0 0];
                Eg = 40*[1 1 1 1 1 1 1 1];
                mu = 1e22;
                alpha = 1.5;
                initialPopulation = [initialPopulation,P,Q,R,Ef,Eg,H,mu,alpha];
                lb = [lb,zeros(1,52),100,1];
                ub = [ub,1e9*ones(1,18),1e3*ones(1,8),1e5*ones(1,26),1e30,100];
                nvars = 66;
                initialPopulation = [initialPopulation,0,0,0.5];
                lb = [lb,0,0,0];
                ub = [ub,1,1,1];
                nvars = nvars + 3;
            case 'RLQ-R Active'
                initialPopulation = [70 70 100 40 40 40 40 40 70 15 15 2];
                lb = zeros(1,12);
                ub = [1000 1000 1000 1000 1000 1000 1000 1000 1000 100 100 100];
                Q = [1e4, 1e4, 1e3,1e-1,1e-1,1e-1];
                P = Q;
                R = 70*[1,1,.1];
                Ef = 0.1*[2 2 1 0 0 0];
                Eg = 0.02*[1 1 1];
                H = [1 1 1 1 1 1];
                mu = 1e30;
                alpha = 1.5;
                initialPopulation = [initialPopulation,P,Q,R,Ef,Eg,H,mu,alpha];
                lb = [lb,zeros(1,30),100,1];
                ub = [ub,1e7*ones(1,15),1e3*ones(1,15),1e30,100];
                nvars = 44;
                initialPopulation = [initialPopulation,0,0,0.5];
                lb = [lb,0,0,0];
                ub = [ub,1,1,1];
                nvars = nvars + 3;
            case 'RLQ-R Active Modified'
                initialPopulation = [70 70 60 2 2 40 25 25 30 3 3 3];
                lb = zeros(1,12);
                ub = [1000 1000 1000 1000 1000 1000 1000 1000 1000 100 100 100];
                Q = 500000*[1e1, 1e1, 1e1,1e1,1e1,1e1];
                P = Q;
                R = 0.00001*[1,1,1,1,1,1,1,1];
                Ef = 10*[2 2 1 0 0 0];
                Eg = 1000*[1 1 1 1 1 1 1 1];
                H = [1 1 1 1 1 1];
                mu = 1e20;
                alpha = 1.5;
                initialPopulation = [initialPopulation,P,Q,R,Ef,Eg,H,mu,alpha];
                lb = [lb,zeros(1,40),100,1];
                ub = [ub,1e9*ones(1,12),1e3*ones(1,8),1e5*ones(1,20),1e30,100];
                nvars = 54;
                initialPopulation = [initialPopulation,0,0,0.5];
                lb = [lb,0,0,0];
                ub = [ub,1,1,1];
                nvars = nvars + 3;
            case 'RLQ-R Active Modified with PIDD'
                initialPopulation = [70 70 100 5 5 40 40 40 30 2 2 1];
                lb = zeros(1,12);
                ub = [1000 1000 1000 1000 1000 1000 1000 1000 1000 100 100 100];
                Q = 500000*[1e1, 1e1, 1e1, 1e1, 1e1, 1e1,1e1,1e1,1e1];
                P = Q;
                R = 0.00001*[1,1,1,1,1,1,1,1];
                H = [1 1 1 1 1 1 1 1 1];
                Ef = 10*[1 1 1 1 1 1 0 0 0];
                Eg = 40*[1 1 1 1 1 1 1 1];
                mu = 1e22;
                alpha = 1.5;
                initialPopulation = [initialPopulation,P,Q,R,Ef,Eg,H,mu,alpha];
                lb = [lb,zeros(1,52),100,1];
                ub = [ub,1e9*ones(1,18),1e3*ones(1,8),1e5*ones(1,26),1e30,100];
                nvars = 66;
                initialPopulation = [initialPopulation,0,0,0.5];
                lb = [lb,0,0,0];
                ub = [ub,1,1,1];
                nvars = nvars + 3;
            case 'SOSMC Passive'
                initialPopulation = [174.997702494293 300 100 30.5068874780194 10 56.3103244070821 45.5442130638715 67.1682801840431 70 14.9608910483165 19.8856469805609 14.5400069911463];
                lb = zeros(1,12);
                ub = [1000 1000 1000 1000 1000 1000 1000 1000 1000 100 100 100];
                c = [3 5.14602122010656 3];
                alpha =  [2 2 2.86070139647772];
                lambda = [0.100000000000000 0.100000000000000 0.100000000000000];
                initialPopulation = [initialPopulation,c,lambda,alpha];
                lb = [lb,zeros(1,9)];
                ub = [ub,100*ones(1,9)];
                nvars = 21;
                initialPopulation = [initialPopulation,0.919683129400176 0.938038565240678 0.970144983652350];
                lb = [lb,0,0,0];
                ub = [ub,1,1,1];
                nvars = nvars + 3;
            case 'SOSMC Passive with PIDD'
                initialPopulation = [174.997702494293 300 100 30.5068874780194 10 56.3103244070821 45.5442130638715 67.1682801840431 70 14.9608910483165 19.8856469805609 14.5400069911463];
                lb = zeros(1,12);
                ub = [1000 1000 1000 1000 1000 1000 1000 1000 1000 100 100 100];
                c = 3*[1,1.5,1,2,2,2];
                alpha = 2*[1,1,1.43,2,2,2];
                lambda = .1*[1,1,1,2,2,2];
                initialPopulation = [initialPopulation,c,lambda,alpha];
                lb = [lb,zeros(1,18)];
                ub = [ub,100*ones(1,18)];
                nvars = 30;
                initialPopulation = [initialPopulation,0,0,0.5];
                lb = [lb,0,0,0];
                ub = [ub,1,1,1];
                nvars = nvars + 3;
            case 'SOSMC Passive Direct'
                initialPopulation = [174.997702494293 300 100 30.5068874780194 10 56.3103244070821 45.5442130638715 67.1682801840431 70 14.9608910483165 19.8856469805609 14.5400069911463];
                lb = zeros(1,12);
                ub = [1000 1000 1000 1000 1000 1000 1000 1000 1000 100 100 100];
                c =1.5*[1,1,4,2,2,2];
                alpha = 5500*...
                           [ 1 -1  0.1 -0.001 -0.01 1 ...
                             1  1 -0.1  0.001 -0.01 1 ...
                            -1  1  0.1  0.001  0.01 1 ...
                            -1 -1 -0.1 -0.001  0.01 1 ...
                             1 -1 -0.1 -0.001 -0.01 1 ...
                             1  1  0.1  0.001 -0.01 1 ...
                            -1  1 -0.1  0.001  0.01 1 ...
                            -1 -1  0.1 -0.001  0.01 1];
                lambda = 1000*...
                            [1 -1  0.1 -0.001 -0.001 1 ...
                             1  1 -0.1  0.001 -0.001 1 ...
                            -1  1  0.1  0.001  0.001 1 ...
                            -1 -1 -0.1 -0.001  0.001 1 ...
                             1 -1 -0.1 -0.001 -0.001 1 ...
                             1  1  0.1  0.001 -0.001 1 ...
                            -1  1 -0.1  0.001  0.001 1 ...
                            -1 -1  0.1 -0.001  0.001 1];
                initialPopulation = [initialPopulation,c,lambda,alpha];
                auxLB = [ 0 -1  0 -1 -1 0 ...
                                            0  0 -1  0 -1 0 ...
                                           -1  0  0  0  0 0 ...
                                           -1 -1 -1 -1  0 0 ...
                                            0 -1 -1 -1 -1 0 ...
                                            0  0  0  0 -1 0 ...
                                           -1  0 -1  0  0 0 ...
                                           -1 -1  0 -1  0 0];
                auxUB = [  1  0  1  0  0 1 ...
                                                1  1  0  1  0 1 ...
                                                0  1  1  1  1 1 ...
                                                0  0  0  0  1 1 ...
                                                1  0  0  0  0 1 ...
                                                1  1  1  1  0 1 ...
                                                0  1  0  1  1 1 ...
                                                0  0  1  0  1 1];
                lb = [lb,zeros(1,6),50000*auxLB,50000*auxLB];
                ub = [ub,100*ones(1,6),50000*auxUB,50000*auxUB];
                nvars = 114;
                initialPopulation = [initialPopulation,0,0,0.5];
                lb = [lb,0,0,0];
                ub = [ub,1,1,1];
                nvars = nvars + 3;
            case 'SOSMC Active'
                initialPopulation = [174.997702494293 300 100 30.5068874780194 10 56.3103244070821 45.5442130638715 67.1682801840431 70 14.9608910483165 19.8856469805609 14.5400069911463];
                lb = zeros(1,12);
                ub = [1000 1000 1000 1000 1000 1000 1000 1000 1000 100 100 100];
                c = [3 5.14602122010656 3];
                alpha =  [2 2 2.86070139647772];
                lambda = [0.100000000000000 0.100000000000000 0.100000000000000];
                initialPopulation = [initialPopulation,c,lambda,alpha];
                lb = [lb,zeros(1,9)];
                ub = [ub,100*ones(1,9)];
                nvars = 21;
                initialPopulation = [initialPopulation,0.919683129400176 0.938038565240678 0.970144983652350];
                lb = [lb,0,0,0];
                ub = [ub,1,1,1];
                nvars = nvars + 3;
            case 'SOSMC Active with PIDD'
                initialPopulation = [174.997702494293 300 100 30.5068874780194 10 56.3103244070821 45.5442130638715 67.1682801840431 70 14.9608910483165 19.8856469805609 14.5400069911463];
                lb = zeros(1,12);
                ub = [1000 1000 1000 1000 1000 1000 1000 1000 1000 100 100 100];
                c = 3*[1,1.5,1,2,2,2];
                alpha = 2*[1,1,1.43,2,2,2];
                lambda = .1*[1,1,1,2,2,2];
                initialPopulation = [initialPopulation,c,lambda,alpha];
                lb = [lb,zeros(1,18)];
                ub = [ub,100*ones(1,18)];
                nvars = 30;
                initialPopulation = [initialPopulation,0,0,0.5];
                lb = [lb,0,0,0];
                ub = [ub,1,1,1];
                nvars = nvars + 3;
            case 'SOSMC Active Direct'
                initialPopulation = [174.997702494293 300 100 30.5068874780194 10 56.3103244070821 45.5442130638715 67.1682801840431 70 14.9608910483165 19.8856469805609 14.5400069911463];
                lb = zeros(1,12);
                ub = [1000 1000 1000 1000 1000 1000 1000 1000 1000 100 100 100];
                c =1.5*[1,1,4,2,2,2];
                alpha = 5500*...
                           [ 1 -1  0.1 -0.001 -0.01 1 ...
                             1  1 -0.1  0.001 -0.01 1 ...
                            -1  1  0.1  0.001  0.01 1 ...
                            -1 -1 -0.1 -0.001  0.01 1 ...
                             1 -1 -0.1 -0.001 -0.01 1 ...
                             1  1  0.1  0.001 -0.01 1 ...
                            -1  1 -0.1  0.001  0.01 1 ...
                            -1 -1  0.1 -0.001  0.01 1];
                lambda = 1000*...
                            [1 -1  0.1 -0.001 -0.001 1 ...
                             1  1 -0.1  0.001 -0.001 1 ...
                            -1  1  0.1  0.001  0.001 1 ...
                            -1 -1 -0.1 -0.001  0.001 1 ...
                             1 -1 -0.1 -0.001 -0.001 1 ...
                             1  1  0.1  0.001 -0.001 1 ...
                            -1  1 -0.1  0.001  0.001 1 ...
                            -1 -1  0.1 -0.001  0.001 1];
                initialPopulation = [initialPopulation,c,lambda,alpha];
                auxLB = [ 0 -1  0 -1 -1 0 ...
                                            0  0 -1  0 -1 0 ...
                                           -1  0  0  0  0 0 ...
                                           -1 -1 -1 -1  0 0 ...
                                            0 -1 -1 -1 -1 0 ...
                                            0  0  0  0 -1 0 ...
                                           -1  0 -1  0  0 0 ...
                                           -1 -1  0 -1  0 0];
                auxUB = [  1  0  1  0  0 1 ...
                                                1  1  0  1  0 1 ...
                                                0  1  1  1  1 1 ...
                                                0  0  0  0  1 1 ...
                                                1  0  0  0  0 1 ...
                                                1  1  1  1  0 1 ...
                                                0  1  0  1  1 1 ...
                                                0  0  1  0  1 1];
                lb = [lb,zeros(1,6),50000*auxLB,50000*auxLB];
                ub = [ub,100*ones(1,6),50000*auxUB,50000*auxUB];
                nvars = 114;
                initialPopulation = [initialPopulation,0,0,0.5];
                lb = [lb,0,0,0];
                ub = [ub,1,1,1];
                nvars = nvars + 3;
            case 'Adaptive'
                initialPopulation = [70 70 100 10 10 40 40 40 70 15 15 2];
                lb = zeros(1,12);
                ub = [1000 1000 1000 1000 1000 1000 1000 1000 1000 100 100 100];
                Am = -2*[1,1,1e-2];
                Q = 1*[.5,.5,.0005];
                gamma1 = [1,1,2]*.8;
                gamma2 = [1,1,2]*.2;
                gamma3 = [1,1,.1]*10;
                gamma4 = [1,1,1]*0;
                initialPopulation = [initialPopulation,Am,Q,gamma1,gamma2,gamma3,gamma4];
                lb = [lb,-50*ones(1,3),zeros(1,15)];
                ub = [ub,zeros(1,3),50*ones(1,15)];
                nvars = 30;
                initialPopulation = [initialPopulation,0,0,0.5];
                lb = [lb,0,0,0];
                ub = [ub,1,1,1];
                nvars = nvars + 3;
            case 'Adaptive with PIDD'
                initialPopulation = [70 70 100 10 10 40 40 40 70 15 15 2];
                lb = zeros(1,12);
                ub = [1000 1000 1000 1000 1000 1000 1000 1000 1000 100 100 100];
                Am = -[.1,.1,2,2,2,0.01];
                Q = [1,1,1,.5,.5,.0005];
                gamma1 = [1,1,1,1,1,1]*.0001;
                gamma2 = [1,1,1,1,1,1]*.0001;
                gamma3 = [1,1,1,1,1,1]*.001;
                gamma4 = [1,1,1,1,1,1]*.00001;
                initialPopulation = [initialPopulation,Am,Q,gamma1,gamma2,gamma3,gamma4];
                lb = [lb,-50*ones(1,6),zeros(1,30)];
                ub = [ub,zeros(1,6),50*ones(1,30)];
                nvars = 48;
                initialPopulation = [initialPopulation,0,0,0.5];
                lb = [lb,0,0,0];
                ub = [ub,1,1,1];
                nvars = nvars + 3;
            case 'Adaptive Direct'
                initialPopulation = [60 60 100 20 20 40 40 40 70 15 15 2];
                lb = zeros(1,12);
                ub = [1000 1000 1000 1000 1000 1000 1000 1000 1000 100 100 100];
                Am = -[.1,.1,2,0.001,0.001,0.001];
                Q = [1,1,1,0.005,0.005,.0005];
                gamma1 = ones(1,8)*700;
                gamma2 = ones(1,8)*700;
                gamma3 = ones(1,8)*2000;
                gamma4 = ones(1,8)*0.5;
                B0 = 5e3*[ -0.00001 -0.00001 4  1.5 -1.5  -3 ...
                             0.00001 -0.00001 4  1.5  1.5 3  ...
                             0.00001  0.00001 4 -1.5  1.5  -3  ...
                            -0.00001  0.00001 4 -1.5 -1.5 3 ...
                            -0.00001 -0.00001 4  1.5 -1.5 3 ...
                             0.00001 -0.00001 4  1.5  1.5  -3  ...
                             0.00001  0.00001 4 -1.5  1.5 3  ...
                            -0.00001  0.00001 4 -1.5 -1.5  -3];

                                  auxLB = [ 1  1  0  0  1  1 ...
                                            0  1  0  0  0  0 ...
                                            0  0  0  1  0  1 ...
                                            1  0  0  1  1  0 ...
                                            1  1  0  0  1  0 ...
                                            0  1  0  0  0  1 ...
                                            0  0  0  1  0  0 ...
                                            1  0  0  1  1  1];

                                     auxUB = [ 0  0  1  1  0  0 ...
                                               1  0  1  1  1  1 ...
                                               1  1  1  0  1  0 ...
                                               0  1  1  0  0  1 ...
                                               0  0  1  1  0  1 ...
                                               1  0  1  1  1  0 ...
                                               1  1  1  0  1  1 ...
                                               0  1  1  0  0  0];
                initialPopulation = [initialPopulation,Am,Q,gamma1,gamma2,gamma3,gamma4,B0];
                lb = [lb,-100*ones(1,6),zeros(1,38),-25e3*auxLB];
                ub = [ub,zeros(1,6),50*ones(1,6),10000*ones(1,32),25e3*auxUB];
                nvars = 104;
                initialPopulation = [initialPopulation,0,0,0.5];
                lb = [lb,0,0,0];
                ub = [ub,1,1,1];
                nvars = nvars + 3;
            case 'Markovian RLQ-R Passive Modified'
                modes = [1 1 1 1 1 1 1 1
                         0 1 1 1 1 1 1 1
                         0 0 1 1 1 1 1 1
                         0 0 0 1 1 1 1 1
                         0 0 0 0 1 1 1 1];
                numberOfModes = size(modes,1);
                initialPopulation = [40 40 80 12 12 12 15 15 15 1.5 1.8 1.5];
                lb = zeros(1,12);
                ub = [1000 1000 1000 1000 1000 1000 1000 1000 1000 100 100 100];
                Ef =[10 10 10 10 10 10 ...
                     10 10 10 10 10 10 ...
                     10 10 10 10 10 10 ...
                     10 10 10 10 10 10 ...
                     10 10 10 10 10 10];
                Eg = [1000 1000 1000 1000 1000 1000 1000 1000 ...
                      1000 1000 1000 1000 1000 1000 1000 1000 ...
                      1000 1000 1000 1000 1000 1000 1000 1000 ...
                      1000 1000 1000 1000 1000 1000 1000 1000 ...
                      1000 1000 1000 1000 1000 1000 1000 100];
                k = 1;
                Er = [0.000001*modes(1,:)+~modes(1,:) ...
                      0.000001*modes(2,:)+~modes(2,:) ...
                      0.000001*modes(3,:)+~modes(3,:) ...
                      0.000001*modes(4,:)+~modes(4,:) ...
                      0.000001*modes(5,:)+~modes(5,:)];
                Eq = [1 1 1 1e-6 1e-6 1e-6 ...
                      1 1 1 1e-6 1e-6 1e-6 ...
                      1 1 1 1e-6 1e-6 1e-6 ...
                      1 1 1 1e-6 1e-6 1e-6 ...
                      1 1 1 1e-6 1e-6 1e-6];
                lambda = 1;
                pij = 0.5;
                eij = 2;
                initialPopulation = [initialPopulation,Ef,Eg,k,Er,Eq,lambda,pij,eij];
                lb = [lb,zeros(1,70),1,zeros(1,70),1e-8*ones(1,3)];
                ub = [ub,1e5*ones(1,70),500,ones(1,40),1e5*ones(1,30),100*ones(1,3)];
                nvars = 156;
                initialPopulation = [initialPopulation,0,0,0.5];
                lb = [lb,0,0,0];
                ub = [ub,1,1,1];
                nvars = nvars + 3;
            case 'Markovian RLQ-R Active Modified'
                modes = [1 1 1 1 1 1 1 1
                         0 1 1 1 1 1 1 1
                         0 0 1 1 1 1 1 1
                         0 0 0 1 1 1 1 1
                         0 0 0 0 1 1 1 1];
                numberOfModes = size(modes,1);
                initialPopulation = [40 50 60 10 12 10 15 15 15 1.5 1.8 0];
                lb = zeros(1,12);
                ub = [1000 1000 1000 1000 1000 1000 1000 1000 1000 100 100 100];
                Q =[50000*[1e10, 1e10, 1e1,1e-1,1e-1,1e-1] ...
                    50000*[1e10, 1e10, 1e1,1e-1,1e-1,1e-1] ...
                    50000*[1e10, 1e10, 1e1,1e-1,1e-1,1e-1] ...
                    50000*[1e10, 1e10, 1e1,1e-1,1e-1,1e-1] ...
                    50000*[1e10, 1e10, 1e1,1e-1,1e-1,1e-1]];
                R = [1*modes(1,:)+~modes(1,:) ...
                     1*modes(2,:)+~modes(2,:) ...
                     1*modes(3,:)+~modes(3,:) ...
                     1*modes(4,:)+~modes(4,:) ...
                     1*modes(5,:)+~modes(5,:)];
                Ef = [10000*ones(1,6) ...
                      10000*ones(1,6) ...
                      10000*ones(1,6) ...
                      10000*ones(1,6) ...
                      10000*ones(1,6)];
                Eg = [1000 1000 1000 1000 1000 1000 1000 1000 ...
                      1000 1000 1000 1000 1000 1000 1000 1000 ...
                      1000 1000 1000 1000 1000 1000 1000 1000 ...
                      1000 1000 1000 1000 1000 1000 1000 1000 ...
                      1000 1000 1000 1000 1000 1000 1000 1000];
                H = [1 1 1 1 1 1 ...
                     1 1 1 1 1 1 ...
                     1 1 1 1 1 1 ...
                     1 1 1 1 1 1 ...
                     1 1 1 1 1 1];
                pij = 0.5;
                ei = 2;
                k = 1;
                mu = 1e10;
                alpha = 1.5;
                initialPopulation = [initialPopulation,Q,R,Ef,Eg,H,pij,ei,k,mu,alpha];
                lb = [lb,zeros(1,170),1e-8*[1 1],1,100,1];
                ub = [ub,1e9*ones(1,30),1e3*ones(1,40),1e5*ones(1,100),100*[1 1],500,1e30,100];
                nvars = 187;
                initialPopulation = [initialPopulation,0,0,0.5];
                lb = [lb,0,0,0];
                ub = [ub,1,1,1];
                nvars = nvars + 3;
        end

        switch controlAllocator
            case 'Adaptive'
                caGain = -2e12*[1,1,1,1,1,1];
                initialPopulation = [initialPopulation,caGain];
                lb = [lb,-inf(1,6)];
                ub = [ub,zeros(1,6)];
                nvars = nvars + 6;
        end
    %     initialPopulation = [initialPopulation;initialPopulation;initialPopulation;initialPopulation]

    %% Check for restore file
    if fullfilename ~= 0
        savedState = load(fullfilename,'state');
        %initialPopulationAux = savedState.state(end).Population;
        initialPopulation = savedState.state(end).Population;
        %fitnessValues = savedState.state(end).Score;
        %initialPopulation = initialPopulationAux(find(fitnessValues==min(fitnessValues)),:)
    end
    fitnessfcn = @(x) controlFitness(attitudeController, controlAllocator, attitudeReference, x);
    %% Start GA
    filename = ['Results/',attitudeController,'_',controlAllocator,'_',attitudeReference,'_',datestr(now),'_result.mat'];
    iterFilename = ['Results/',attitudeController,'_',controlAllocator,'_',attitudeReference,'_',datestr(now),'_iterations.mat'];
    outFunction = @(options,state,flag) saveIter(options,state,flag,iterFilename);
    options = gaoptimset('PopulationSize',3000,'Generations',150,'Display','iter','InitialPopulation',initialPopulation,'OutputFcn',outFunction,'Vectorized','on','CrossoverFraction',0.5,'MutationFcn', {@mutationuniform, 0.05}, 'StallGenLimit',25);
    poolobj = parpool(80);
    addAttachedFiles(poolobj,{'controlFitness.m','saveIter.m','paramsToMultirotor.m','../multiControl/'})
    [bestIndividual,bestFitness, EXITFLAG,OUTPUT,POPULATION,SCORES] = ga(fitnessfcn,nvars,[],[],[],[],lb,ub,[],options);
    delete(poolobj)
    finishDate = datestr(now);
    save(filename,'attitudeController','controlAllocator','attitudeReference','bestIndividual','bestFitness','EXITFLAG','OUTPUT','POPULATION','SCORES','finishDate','options','initialPopulation');
end
