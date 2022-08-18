
function fuzzy()


//------- Recebendo os valores necessários para o cálculo -------

ppf = input("Pressão no pedal do freio: ")
vr = input("Velocidade da roda: ")
vc = input("Velocidade do carro: ")


//------- Função para calcular o pertencimento de um valor x dada uma função triangular estabelecida com os valores (a, b, c) -------
deff('y = f(x, r, s, t)', 'y=max(min((x-r)/(s-r),(t-x)/(t-s)), 0)')


//------- Aplicação das regras --------

//Regra 1:

ppf_med = f(ppf,30, 50, 70)  //Se a pressão no pedal do freio for média
af = ppf_med                //Então, aplicar o freio

//Regra 2:

ppf_alta = f(ppf, 50, 100, 100)               //Se a pressão no pedal de freio for alta
vc_alta = f(vc, 40, 100, 100)                //E a velocidade do carro for alta
vr_alta = f(vr, 40, 100, 100)               //E a velocidade das rodas for alta
af = af + min(ppf_alta, vc_alta, vr_alta)  //Então, aplicar o freio (AND entre as sentenças->min()) ---- É desejada a soma dos af's

//Regra 3:

vr_baixa = f(vr, 0, 0, 60)                  //Se a velocidade das rodas for baixa
//os valores gerados pelas outras sentenças da Regra 3 já foram calculados na regra anterior
lf = min(ppf_alta, vc_alta, vr_baixa)       //Então, liberar o freio (AND entre as sentenças->min())

//Regra 4:
ppf_baixa = f(ppf, 0, 0, 50)             //Se a pressão no pedal de freio for baixa
lf = lf+ppf_baixa                        //Então, liberar o freio ---- É desejada a soma dos lf's






//----------------- Cálculo do centroide -----------------------


//Cálculo de a, b e c

if lf>af then
a=100-100*lf 
b=100-100*af    
else
a=100*lf 
b=100*af
end

c=100


//Cálculo do maior e do menor valor entre af e lf

maior = max(af, lf)
menor = min(af, lf)


//Cálculo das áreas

A1 = a*lf
A2 = (b-a)*(maior-menor)/2  
A3 = (b-a)*menor
A4 = af*(c-b)


//Cálculo do centroide de cada parte

x1 = a/2

if lf>af then
x2 = (2*a+b)/3
else
x2 = (a+2*b)/3
end

x3 = (a+b)/2
x4 = (b+c)/2


//Cáculo do somatório das multiplicações entre o valor de cada área pelo valor do centroide correspondente
somaxarea = A1*x1+A2*x2+A3*x3+A4*x4


//Soma das áreas
somarea = A1+A2+A3+A4 


//Calculo da pressão no freio

pf = somaxarea/somarea
disp('pressao no freio', pf)

//----------------- Plot -----------------
function  y = piece(x) 

if a<=50 & 50<=b | a==b & a<50 then

// primeira parte
y(x <= a) = lf

// segunda parte
x2 = a < x & x <= b

if lf>af then
    y(x2) = 1 - x(x2)/100
    
 else 
     y(x2) = x(x2)/100
end

else   // Caso especial
// primeira parte (caso especial)
y(x <= 100-a) = lf

// segunda parte (caso especial)
x2 = 100-a < x & x <=50
y(x2) = 1 - x(x2)/100

// terceira parte (caso especial)
x3 = 50 < x & x <a
y(x3) = x(x3)/100
end

// terceira parte
y(b <= x & x <= c) = af
endfunction

x = [0:100]'
y = piece(x)
plot(x,y)
xlabel("Pressão no freio", "fontsize", 2)
a = gca()
a.data_bounds = [0 0; c 1]

endfunction























