function [] = dibujarMuellesRapido(x, t, step)
  
  n = size(x)(2) / 4;
  
  N1 = (1:n).*2-1;
  N2 = N1 + 1;
  
  X = Y = zeros(1, n);
  
  scatter(X, Y, 'xdatasource', 'X', 'ydatasource', 'Y', 'filled');
  
  xlim([-1 16]);
  ylim([-1 10]);
  delta = 0;
  
  i = 1;
  while i < length(t)

    delta -= time();
    
    X = x(i, N1);
    Y = x(i, N2);
        
    refreshdata(gcf, "caller");
    delta += time();
    
    if delta < step
      pause(step - delta);
      delta = 0;
    else
      delta -= step;

      % En casos extremos, salteo muestras
      while delta > step
        delta -= step;
        i++;
      endwhile

      % Necesito esperar un poco para
      % que se vea el grafico actualizado
      pause(.005);
      delta += .005;
    endif
    
    i++;
  endwhile
  
endfunction
