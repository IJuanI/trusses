% Formato de entrada:
% puntos []
%   posicion: vec
%   fuerza: @(t) -> vec
%   fijar []  -- un booleano por dimension
%   uniones
%     sum []
%       idx: int
%       k: int
%     res []
%       idx: int
%       k: int
function [f] = calcularFuerzas(t, Y, puntos)
  cantidad = length(puntos);
  dimension = length(puntos(1).posicion);
  
  ancho = dimension*cantidad;
  
  for i = 1:cantidad
    fuerzas = cuerpoLibre(t, Y, puntos, i, dimension, ancho);
    k = dimension * (i-1);
    f(k+(1:dimension)) = fuerzas(1:dimension);
  endfor
  
endfunction

function [f] = cuerpoLibre(t, Y, puntos, puntoIdx, dimension, ancho)
  for i = 1:dimension
    f(i) = calcularComponente(t, Y, puntos, puntoIdx, i, ancho);
  endfor
endfunction

function [f] = calcularComponente(t, Y, puntos, puntoIdx, componente, ancho)
  f = 0;
  punto = puntos(puntoIdx);
  if !isfield(punto, 'fijar') || length(punto.fijar) < componente || !punto.fijar(componente)
    if isfield(punto, 'uniones')
      
      % Uniones que aparecen sumando
      for union = punto.uniones
        x1_0 = puntos(puntoIdx).posicion;
        x2_0 = puntos(union.idx).posicion;
      
        x1 = Y((-1:0) + (2*puntoIdx));
        x2 = Y((-1:0) + (2*union.idx));
      
        stretch = norm(x1_0 - x2_0) / norm(x2 - x1);
        f += calcularFuerzaInterna(union.k, x1(componente), x2(componente), stretch);
      endfor
    endif
    
    if isfield(punto, 'fuerza') && isvector(punto.fuerza)
      f += punto.fuerza(t)(componente);
    endif
  endif
endfunction

function [f] = calcularFuerzaInterna(k, x1, x2, stretch)
  f = k * (1 - stretch) * (x2 - x1);
endfunction