if !exist('X')
  
  if !exist('L')
    L = 5;
  endif
  
  if !exist('m')
    m = .5;
  endif
  
  if !exist('k')
    k = 20;
  endif
  
  if !exist('ti')
    ti = 0;
  endif
  
  if !exist('tf')
    tf = 50;
  endif
  
  if !exist('dt')
    dt = .05;
  endif
  
  if !exist('simSpeed')
    simSpeed = 1;
  endif
  
  X = [];
  
  printf 'Los valores iniciales son:\n';
  printf (' * L = %d\n', L);
  printf (' * m = %d\n', m);
  printf (' * k = %d\n', k);
  printf (' * ti = %d\n', ti);
  printf (' * tf = %d\n', tf);
  printf (' * dt = %d\n', dt);
  printf (' * simSpeed = %d\n', simSpeed);
  printf '\nPuede modificar cualquiera de estos valores.\n'
  printf 'Para alterar las fuerzas o forma del reticulado, editar el script\n'
  printf '\nPara correr la simulación, vuelva a ejecutar el script.\n';

else

  clear punto;
  clear uniones;
  
  % Configuración de fuerza, contorno y forma
  v = [0, 0];
  
  punto(1).posicion = [0, 0];
  punto(1).fijar(1) = true;
  punto(1).fijar(2) = true;
  
  punto(2).posicion = [0, L];
  punto(2).fijar(1) = true;
  punto(2).fijar(2) = true;
  
  punto(3).posicion = [L, 0];
  punto(4).posicion = [L, L];
  punto(5).posicion = [2*L, 0];
  punto(6).posicion = [2*L, L];
  
  punto(7).posicion = [3*L, 0];
  punto(7).fuerza = @(t) [0, -5];
  
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
  
  [Y, punto, m] = prepararDatos(ti, tf, punto, uniones, m, v, k);
  
  % Preparar la gráfica
  n = 2*length(punto);
  uN = length(uniones);
  t = ti;
  
  clear Xp;
  clear Yp;
  
  clf;
  hold on;
  
  for i = 1:uN
    Xp.(num2str(i)) = [0, 0];
    Yp.(num2str(i)) = [0, 0];
    line(Xp.(num2str(i)), Yp.(num2str(i)),
        'xdatasource', ["Xp.('" num2str(i) "')"],
        'ydatasource', ["Yp.('" num2str(i) "')"],
        'color', 'b');
  endfor
  
  xlim([-1 16]);
  ylim([-1 10]);
  delta = -time();
  
  % Main loop
  while t < tf
        
    for j = 1:uN
      Xp.(num2str(j)) = Y(uniones(j, 1:2).*2-1);
      Yp.(num2str(j)) = Y(uniones(j, 1:2).*2);
    endfor
    
    refreshdata(gcf, "caller");
    
    [Y, t] = computarPaso(Y, t, punto, n, dt, m);
    
    [delta, skips] = analizarTiempos(delta, dt / simSpeed);
    
    % Si la simulacion está muy rápida, salteo pasos
    for i = 1:skips
      [Y, t] = computarPaso(Y, t, punto, n, dt, m);
    endfor

  endwhile
  
endif


function [Y, t] = computarPaso(Y, t, puntos, n, dt, m)
  
  f = calcularFuerzas(t, Y, puntos);
    
  Y(n+1:2*n) += f(1:n)./ m * dt;
  Y(1:n) += Y(n+1:2*n) .* dt;

  t += dt;
  
endfunction

function [delta, skips] = analizarTiempos(delta, paso)
    skips = 0;
    
    delta += time();
    
    if delta < paso
      pause(paso - delta);
      delta = 0;
    else
      delta -= paso;

      % En casos extremos, salteo muestras
      while delta > paso
        delta -= paso;
        skips++;
      endwhile

      % Necesito esperar un poco para
      % que se vea el grafico actualizado
      pause(.005);
      delta += .005;
    endif
  
    delta -= time();
    
endfunction
