%% Hacer DTW (fases vs circuios)
%%Leer Archivos txt
% clear all;clc;
filename = 'bloque';
senal_circuitos = load('senal_circuito.txt'); senal_fase = load('senal_fase.txt');
dif_fase = load('dif_fase.txt'); dif_circuitos = load('dif_circuito.txt'); 
% Archivotxt = strcat(filename,'.txt'); 
% senales = load(Archivotxt);
fase = {}; circuitos = {}; resta = {};

%%Limites datos  
inicio_fase = 165890; %Modificar a mano viendo graficas
inicio_circuitos = 5958024;

senal_fase = senal_fase(inicio_fase:end);
senal_circuitos = senal_circuitos(inicio_circuitos:end);

dif_fase = dif_fase(inicio_fase:end);
dif_circuitos = dif_circuitos(inicio_circuitos:end);

%probar si se corto bien
%figure(1);plot(senal_fase);hold all;plot(senal_circuitos);

tiempo_fase = sum(dif_fase);
tiempo_circuitos = sum(dif_circuitos);

tiempo = 1; dif = tiempo*3600*1000;

[inicios_fase, finales_fase]= limites(dif_fase,dif);
[inicios_circuitos, finales_circuitos] = limites(dif_circuitos, dif);

inicios_fase = inicios_fase + 1; finales_fase = finales_fase + 1;
inicios_circuitos = inicios_circuitos + 1; finales_circuitos = finales_circuitos + 1;

%%aplicar DTW

% for i = 1:round(length(senal_circuitos)/7000)
% dtw(senal_circuitos(1+(i-1)*7000:i*7000),senal_fase(1+(i-1)*7000:i*7000));

 for i = 1:length(inicios_fase)-1
     
dtw(senal_circuitos(inicios_circuitos(i):finales_circuitos(i)),senal_fase(inicios_fase(i):finales_fase(i)));

savefig(strcat(filename,num2str(i),'.fig'));

close all

figg = openfig(strcat(filename,num2str(i),'.fig'));
axObjs = figg.Children;
dataObjs = axObjs.Children;

y_fase = dataObjs(1).YData;
y_circuitos = dataObjs(2).YData;
y_resta = y_fase - y_circuitos;
y_resta = y_resta(y_resta >0);

% fase(inicios_fase(i):finales_fase(i)) = y_fase;
% circuitos(inicios_circuitos(i):finales_circuitos(i)) = y_circuitos;
% resta(inicios_fase(i):finales_fase(i)) = y_resta;

  fase{i} = y_fase';
  circuitos{i} =  y_circuitos';
  resta{i} = y_resta';

 end 

close all 

Fase = cat(1,fase{:});
Circuitos = cat(1,circuitos{:});
Resta = cat(1,resta{:});

figure(1)
plot(Fase);hold all; plot(Circuitos);
figure(2)
plot(Resta)

%% Funcion
function [inicios,finales] = limites(dif_senal, dif)

inicio = 0; final = 0; suma = 0; inicios = [];finales = [];

% for i = 1:length(dif_senal)
while 1
    while suma < dif
        try
            final = final+1;
            suma = suma + dif_senal(final);
        catch
            %final = final-1;
        break
        end
    end
        inicios = cat(1,inicios,inicio);%horzcat
        finales = cat(1,finales,final);
        inicio = final+1;
        suma = 0;
    if final > length(dif_senal)%==
    break
    end
end
end






