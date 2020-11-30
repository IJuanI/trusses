function [] = dibujarMuelles2D(x, t, step, uniones)
  
  uN = length(uniones);
  
  for i = 1:uN
    X.(num2str(i)) = [0, 0];
    Y.(num2str(i)) = [0, 0];
  endfor
  
  hold on;
  
  for i = 1:uN
   line(X.(num2str(i)), Y.(num2str(i)),
        'xdatasource', ["X.('" num2str(i) "')"],
        'ydatasource', ["Y.('" num2str(i) "')"],
        'color', 'b');
  endfor
  
  xlim([-1 16]);
  ylim([-1 10]);
  delta = 0;
  
  i = 1;
  while i < length(t)

    delta -= time();
    
    for j = 1:uN
      X.(num2str(j)) = x(i, uniones(j, 1:2).*2-1);
      Y.(num2str(j)) = x(i, uniones(j, 1:2).*2);
    endfor
    
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
  
endfunction
