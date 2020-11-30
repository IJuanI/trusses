% Formato de entrada:
% ti: int                -- Tiempo Inicial
% tf: int                -- Tiempo Final
% puntos []
%   posicion: vec        -- obligatorio
%   fuerza: @(t) -> vec  -- opcional
%   velocidad: vec       -- opcional
%   fijar []             -- opcional, un booleano por dimension
% uniones []             -- obligatorio
%   - vec + k            -- Lista de vectores, puede llevar k al final
% masas: int ó vec       -- obligatorio
% velocidad: int         -- obligatorio, velocidad por defecto
% k: int                 -- obligatorio si faltan datos, Constante del muelle
function [Y0, puntos, masas] = prepararDatos(ti, tf, puntos, uniones, masas, velocidad, k)

  cantidad = length(puntos);
  dimension = length(puntos(1).posicion);
  
  % Inicializo masas
  if isvector(masas)
    masas = ones(1, 2*cantidad) * masas;
  endif

  % Preparo las uniones
  ulength = length(uniones);
  for i = 1:cantidad
    slength = 1;

    for uIdx = 1:ulength
      u = uniones(uIdx, :);
      if u(1) == i || u(2) == i
        if u(1) == i
          puntos(i).uniones(slength).idx = u(2);
        else
          puntos(i).uniones(slength).idx = u(1);
        endif
        
        if length(u) > 2
          puntos(i).uniones(slength).k = u(3);
        else
          puntos(i).uniones(slength).k = k;
        endif
        slength++;
      endif
    endfor
  endfor
  
  anchoSistema = cantidad*dimension;
  
  for i = 1:cantidad
    base = dimension*(i-1);
    
    for j = 1:dimension
      Y0(base+j) = puntos(i).posicion(j);
      if isfield(puntos(i), 'velocidad')
        Y0(base+j+anchoSistema) = puntos(i).velocidad(j);
      else
        Y0(base+j+anchoSistema) = velocidad(j);
      endif
    endfor
  endfor

endfunction
