n = 14;

if !exist('Y') || !isvector('Y') || length(Y) != 2*n || !exist('f')
  Y = [
    % Posiciones
    [0 0 0 5 5 0 5 5 10 0 10 5 15 0]'
    % Velocidades
    [0 0 0 0 0 0 0 0  0 0  0 0  0 0]'
  ];
  
  clear punto;
  clear uniones;
  
  m = .5;
  k = 40;
  
  punto(1).posicion = [0, 0];
  punto(1).fijar(1) = true;
  punto(1).fijar(2) = true;
  punto(1).uniones(1).idx = 3;
  punto(1).uniones(1).k = k;

  punto(2).posicion = [0, 5];
  punto(2).fijar(1) = true;
  punto(2).fijar(2) = true;
  punto(2).uniones(1).idx = 3;
  punto(2).uniones(1).k = k;
  punto(2).uniones(2).idx = 4;
  punto(2).uniones(2).k = k;
  
  punto(3).posicion = [5, 0];
  punto(3).uniones(1).idx = 4;
  punto(3).uniones(1).k = k;
  punto(3).uniones(2).idx = 5;
  punto(3).uniones(2).k = k;
  punto(3).uniones(3).idx = 1;
  punto(3).uniones(3).k = k;
  punto(3).uniones(4).idx = 2;
  punto(3).uniones(4).k = k;
  
  punto(4).posicion = [5, 5];
  punto(4).uniones(1).idx = 5;
  punto(4).uniones(1).k = k;
  punto(4).uniones(2).idx = 6;
  punto(4).uniones(2).k = k;
  punto(4).uniones(3).idx = 2;
  punto(4).uniones(3).k = k;
  punto(4).uniones(4).idx = 3;
  punto(4).uniones(4).k = k;

  punto(5).posicion = [10, 0];
  punto(5).uniones(1).idx = 3;
  punto(5).uniones(1).k = k;
  punto(5).uniones(2).idx = 4;
  punto(5).uniones(2).k = k;
  punto(5).uniones(3).idx = 6;
  punto(5).uniones(3).k = k;
  punto(5).uniones(4).idx = 7;
  punto(5).uniones(4).k = k;
  
  punto(6).posicion = [10, 5];
  punto(6).uniones(1).idx = 4;
  punto(6).uniones(1).k = k;
  punto(6).uniones(2).idx = 5;
  punto(6).uniones(2).k = k;
  punto(6).uniones(3).idx = 7;
  punto(6).uniones(3).k = k;
  
  punto(7).posicion = [15, 0];
  punto(7).uniones(1).idx = 5;
  punto(7).uniones(1).k = k;
  punto(7).uniones(2).idx = 6;
  punto(7).uniones(2).k = k;
  punto(7).fuerza = @(t) [0 -5];
  
  uniones = [
    [1, 3],
    [2, 3],
    [2, 4],
    [3, 4],
    [3, 5],
    [4, 5],
    [4, 6],
    [5, 6],
    [5, 7],
    [6, 7]
  ];
  
endif

if !exist('t') || !isnumeric(t) || !exist('f')
  t = 0;
  dt = 1;
else
  t += dt;
  Y(n+1:2*n) += f(1:n)' .* (dt / m);
  Y(1:n) += Y(n+1:2*n) .* dt;
endif;

f = calcularFuerzas(t, Y, punto);

if !exist('x') || (ismatrix(x) && (length(x) == 0 || size(x)(2) == 2*n))
  if exist('x')
    xn = size(x)(1);
  else
    xn = 0;
  endif
  
  x(xn+1, 1:2*n) = Y';
endif
