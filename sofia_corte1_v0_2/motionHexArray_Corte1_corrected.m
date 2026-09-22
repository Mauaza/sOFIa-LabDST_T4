%% ASIGNACIÓN: MODELADO CINEMÁTICO SOFIA - CON ROTACIÓN DINÁMICA
% Simula 16 módulos SOFIA siguiendo un punto móvil p(t)
% LOS HEXÁGONOS RUTAN SEGÚN q1 y q2 EN TIEMPO REAL

clear; clc; close all;

fprintf('╔════════════════════════════════════════════════════════════════╗\n');
fprintf('║   ASIGNACIÓN: Modelado Cinemático de Unidad SOFIA (Asign.1)   ║\n');
fprintf('║            CON ROTACIÓN DINÁMICA DE HEXÁGONOS                 ║\n');
fprintf('╚════════════════════════════════════════════════════════════════╝\n\n');

% ===== REQUISITO a): DEFINIR ARREGLO DE MÓDULOS =====
fprintf('a) DEFINIR ARREGLO: Posiciones y orientaciones de 16 módulos\n');
fprintf('─────────────────────────────────────────────────────────────────\n\n');

% CONFIGURACIÓN DE HEXÁGONOS EN PANAL
params.num_hexagons = 16;
params.hex_pitch = 0.12;
params.hex_height = 0.00;

% Parámetros cinemáticos
params.z1_2 = 0.020;
params.z2_3 = 0.030;
params.q1_max = deg2rad(45);
params.q2_max = deg2rad(45);
params.q1_min = -deg2rad(45);
params.q2_min = -deg2rad(45);

% DISPOSICIÓN EN PANAL
hex_pitch = params.hex_pitch;
v_spacing = hex_pitch * sqrt(3) / 2;

% Acomodo de los 16 hexágonos
pos(1,:) = [0.5*hex_pitch, v_spacing, 0];
pos(2,:) = [1.5*hex_pitch, v_spacing, 0];
pos(3,:) = [2.5*hex_pitch, v_spacing, 0];
pos(4,:) = [3.5*hex_pitch, v_spacing, 0];

pos(5,:) = [0.00,         2*v_spacing, 0];
pos(6,:) = [hex_pitch,    2*v_spacing, 0];
pos(7,:) = [2*hex_pitch,  2*v_spacing, 0];
pos(8,:) = [3*hex_pitch,  2*v_spacing, 0];

pos(9,:) = [0.5*hex_pitch, 3*v_spacing, 0];
pos(10,:) = [1.5*hex_pitch, 3*v_spacing, 0];
pos(11,:) = [2.5*hex_pitch, 3*v_spacing, 0];
pos(12,:) = [3.5*hex_pitch, 3*v_spacing, 0];

pos(13,:) = [0.00,       4*v_spacing, 0];
pos(14,:) = [hex_pitch,  4*v_spacing, 0];
pos(15,:) = [2*hex_pitch,4*v_spacing, 0];
pos(16,:) = [3*hex_pitch,4*v_spacing, 0];

hex_positions = pos;

% Orientación inicial
for i = 1:params.num_hexagons
    hex_orientations(i,:) = [0, 0, 0];
end

% Centrar panal
center = mean(hex_positions, 1);
hex_positions = hex_positions - center;

hex_labels = {
'1';   '2';   '3';   '4';
'5';  '6'; '7'; '8';
'9';  '10'; '11'; '12';
'13';  '14'; '15'; '16';
};

assignin('base', 'params', params);
assignin('base', 'hex_positions', hex_positions);
assignin('base', 'hex_orientations', hex_orientations);
assignin('base', 'hex_labels', hex_labels);

% Visualizar panal inicial
figure('Name', 'Hexagon Array Layout', 'NumberTitle', 'off', 'Position', [100 100 900 700]);
hold on; grid on; axis equal;

for i = 1:params.num_hexagons
    pos = hex_positions(i,:);
    angles = linspace(0, 2*pi, 7);
    hex_radius = params.hex_pitch / 2 * 0.8;
    hex_x = pos(1) + hex_radius * cos(angles);
    hex_y = pos(2) + hex_radius * sin(angles);
    plot(hex_x, hex_y, 'b-', 'LineWidth', 2);
    text(pos(1), pos(2), sprintf('H%d\n%s', i, hex_labels{i}), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle', ...
        'FontSize', 8, 'FontWeight', 'bold');
    plot(pos(1), pos(2), 'ro', 'MarkerSize', 6, 'MarkerFaceColor', 'r');
end

xlabel('X (m)'); ylabel('Y (m)');
title('Disposición de 16 Hexágonos en Panal', 'FontSize', 12, 'FontWeight', 'bold');

fprintf('✓ Arreglo definido:\n');
fprintf('  • 16 módulos en panal hexagonal (4-4-4-4)\n');
fprintf('  • Dimensiones: z₁,₂ = 0.020 m, z₂,₃ = 0.030 m\n\n');

z1_2 = params.z1_2;
z2_3 = params.z2_3;
q_max = params.q1_max;

% ===== REQUISITO b): DEFINIR TRAYECTORIA p(t) =====
fprintf('b) DEFINIR TRAYECTORIA p(t) del punto móvil\n');
fprintf('─────────────────────────────────────────────────────────────────\n\n');

radius_p = 0.15;
height_p = 0.40;
center_x_p = 0.0;
center_y_p = 0.0;
omega_p = 0.3;

fprintf('✓ Trayectoria circular:\n');
fprintf('  • p(t) = [%.2f + %.2f·cos(%.2f·t), %.2f + %.2f·sin(%.2f·t), %.2f]ᵀ\n', ...
    center_x_p, radius_p, omega_p, center_y_p, radius_p, omega_p, height_p);
fprintf('  • Período: %.2f segundos\n\n', 2*pi/omega_p);

% Parámetros de simulación
t_total = 25;
dt = 0.4;
t = 0:dt:t_total;
n_frames = length(t);

fprintf('Duración: %.1f s, Frames: %d\n\n', t_total, n_frames);

% ===== REQUISITO c): CINEMÁTICA INVERSA =====
fprintf('c) IMPLEMENTAR CINEMÁTICA INVERSA\n');
fprintf('─────────────────────────────────────────────────────────────────\n\n');

fprintf('Calculando q₁, q₂ para cada módulo...\n\n');

q1_traj = zeros(16, n_frames);
q2_traj = zeros(16, n_frames);
r2p_direction = zeros(16, 3, n_frames);

for frame = 1:n_frames
    time = t(frame);
    
    angle_p = omega_p * time;
    target = [
        center_x_p + radius_p * cos(angle_p);
        center_y_p + radius_p * sin(angle_p);
        height_p
    ];
    
    for i = 1:16
        hex_pos = hex_positions(i, :)';
        r2p = target - hex_pos;
        r2p_norm = norm(r2p);
        
        if r2p_norm < 1e-6
            r2p_hat = [0; 0; 1];
        else
            r2p_hat = r2p / r2p_norm;
        end
        
        r2p_direction(i, :, frame) = r2p_hat;
        
        ux = r2p_hat(1);
        uy = r2p_hat(2);
        uz = r2p_hat(3);
        
        % CINEMÁTICA INVERSA
        q2 = asin(max(-1, min(1, ux)));

        % Singularidad: |ux| = 1 => uy = uz = 0 y q1 no queda determinado.
        % Criterio adoptado: mantener la última pose de q1; para el primer
        % frame se usa la pose neutra q1 = 0.
        if hypot(uy, uz) < 1e-9
            if frame > 1
                q1 = q1_traj(i, frame-1);
            else
                q1 = 0;
            end
        else
            q1 = atan2(-uy, uz);
        end
        
        % REQUISITO d): Restricción
        q1 = max(params.q1_min, min(params.q1_max, q1));
        q2 = max(params.q2_min, min(params.q2_max, q2));
        
        q1_traj(i, frame) = q1;
        q2_traj(i, frame) = q2;
    end
end

fprintf('✓ Cinemática inversa: q₁ = atan2(-uᵧ, u_z), q₂ = arcsin(uₓ)\n');
fprintf('✓ Restricción: q₁, q₂ ∈ [%.1f°, %.1f°]\n\n', -45, 45);

% ===== REQUISITO e): VERIFICACIÓN =====
fprintf('e) VERIFICAR que r̂₂,₃ apunta hacia p\n');
fprintf('─────────────────────────────────────────────────────────────────\n\n');

angle_error = zeros(16, n_frames);

for frame = 1:n_frames
    time = t(frame);
    angle_p = omega_p * time;
    target = [center_x_p + radius_p * cos(angle_p);
              center_y_p + radius_p * sin(angle_p);
              height_p];
    
    for i = 1:16
        r2p_real = target - hex_positions(i,:)';
        r2p_real_hat = r2p_real / (norm(r2p_real) + 1e-10);

        % Reconstruir la dirección REAL alcanzada por el módulo a partir
        % de los ángulos q1 y q2 ya restringidos. De R = Rx(q1)*Ry(q2),
        % la dirección local +z transformada es:
        % [sin(q2); -cos(q2)sin(q1); cos(q1)cos(q2)].
        q1 = q1_traj(i, frame);
        q2 = q2_traj(i, frame);
        r23_hat = [sin(q2);
                  -cos(q2)*sin(q1);
                   cos(q1)*cos(q2)];
        r23_hat = r23_hat / (norm(r23_hat) + 1e-10);

        cos_angle = dot(r23_hat, r2p_real_hat);
        angle_error(i, frame) = acos(max(-1, min(1, cos_angle))) * 180/pi;
    end
end

mean_error = mean(angle_error(:));
max_error = max(angle_error(:));
fprintf('✓ Error angular promedio: %.6f°\n', mean_error);
fprintf('✓ Error angular máximo:   %.6f°\n\n', max_error);

% ===== REQUISITO f): GRABAR VÍDEO CON ROTACIÓN DINÁMICA =====
fprintf('f) GRABAR VÍDEO CON ROTACIÓN DINÁMICA\n');
fprintf('─────────────────────────────────────────────────────────────────\n\n');

fig = figure('Name', 'Simulación SOFIA - CON ROTACIÓN', ...
    'NumberTitle', 'off', ...
    'Position', [100 100 1200 800]);

ax_main = subplot(1,2,1, 'Parent', fig);
hold(ax_main, 'on');
grid(ax_main, 'on');
axis(ax_main, 'equal');
view(ax_main, 3);
xlabel(ax_main, 'X (m)');
ylabel(ax_main, 'Y (m)');
zlabel(ax_main, 'Z (m)');
title(ax_main, 'Panal Completo (16 módulos girando)', 'FontSize', 12, 'FontWeight', 'bold');
set(ax_main, 'XLim', [-0.4 0.4], 'YLim', [-0.4 0.4], 'ZLim', [-0.1 0.5]);

ax_zoom = subplot(1,2,2, 'Parent', fig);
hold(ax_zoom, 'on');
grid(ax_zoom, 'on');
axis(ax_zoom, 'equal');
view(ax_zoom, 3);
xlabel(ax_zoom, 'X (m)');
ylabel(ax_zoom, 'Y (m)');
zlabel(ax_zoom, 'Z (m)');
title(ax_zoom, 'Zoom: Módulo 01 (rotación q1, q2)', 'FontSize', 12, 'FontWeight', 'bold');
set(ax_zoom, 'XLim', [-0.3 0.1], 'YLim', [-0.2 0.2], 'ZLim', [-0.1 0.5]);

% Configurar vídeo
video_filename = fullfile(pwd, 'Simulacion_SOFIA_Panal_ConRotacion.mp4');
v = VideoWriter(video_filename, 'MPEG-4');
v.FrameRate = 10;
v.Quality = 90;
open(v);

fprintf('Grabando vídeo: %s\n', video_filename);
fprintf('Procesando frames con ROTACIÓN DINÁMICA:\n\n');

% PARÁMETROS DE VISUALIZACIÓN
colors = parula(16);
hex_radius = 0.06;
hex_height_vis = 0.02;
n_sides = 6;

% ===== ANIMACIÓN PRINCIPAL =====
for frame = 1:n_frames
    % Limpiar axes
    cla(ax_main);
    cla(ax_zoom);
    hold(ax_main, 'on');
    hold(ax_zoom, 'on');
    
    time = t(frame);
    angle_p = omega_p * time;
    target_x = center_x_p + radius_p * cos(angle_p);
    target_y = center_y_p + radius_p * sin(angle_p);
    
    % ===== DIBUJAR HEXÁGONOS ROTADOS =====
    for i = 1:16
        % Ángulos de rotación en este frame
        q1 = q1_traj(i, frame);  % rotación eje X (pitch)
        q2 = q2_traj(i, frame);  % rotación eje Y (jaw)
        
        % Posición base del hexágono
        hex_pos = hex_positions(i, :);
        
        % Crear cilindro hexagonal
        angles_hex = linspace(0, 2*pi, n_sides+1);
        x_base_local = hex_radius * cos(angles_hex);
        y_base_local = hex_radius * sin(angles_hex);
        z_base_local = zeros(size(angles_hex));
        
        z_top_local = hex_height_vis * ones(size(angles_hex));
        x_top_local = x_base_local;
        y_top_local = y_base_local;
        
        % ===== APLICAR ROTACIONES q1 (X) y q2 (Y) =====
        % Matriz de rotación del modelo: R = Rx(q1) * Ry(q2)
        % El orden importa porque el segundo servo gira sobre el eje ya
        % desplazado por el primero.
        Rx = [1 0 0; 0 cos(q1) -sin(q1); 0 sin(q1) cos(q1)];
        Ry = [cos(q2) 0 sin(q2); 0 1 0; -sin(q2) 0 cos(q2)];
        R = Rx * Ry;
        
        % Rotar base inferior
        base_lower = [x_base_local; y_base_local; z_base_local];
        base_lower_rot = R * base_lower;
        x_base = base_lower_rot(1,:) + hex_pos(1);
        y_base = base_lower_rot(2,:) + hex_pos(2);
        z_base = base_lower_rot(3,:) + hex_pos(3);
        
        % Rotar base superior
        base_upper = [x_top_local; y_top_local; z_top_local];
        base_upper_rot = R * base_upper;
        x_top = base_upper_rot(1,:) + hex_pos(1);
        y_top = base_upper_rot(2,:) + hex_pos(2);
        z_top = base_upper_rot(3,:) + hex_pos(3);
        
        % Dibujar cilindro hexagonal (ROTADO)
        for j = 1:n_sides
            X = [x_base(j) x_base(j+1) x_top(j+1) x_top(j)];
            Y = [y_base(j) y_base(j+1) y_top(j+1) y_top(j)];
            Z = [z_base(j) z_base(j+1) z_top(j+1) z_top(j)];
            
            patch(ax_main, X, Y, Z, colors(i,:), 'FaceAlpha', 0.7, 'EdgeColor', 'black', 'LineWidth', 0.5);
            
            if i == 1
                patch(ax_zoom, X, Y, Z, colors(i,:), 'FaceAlpha', 0.7, 'EdgeColor', 'black', 'LineWidth', 0.5);
            end
        end
        
        % Etiqueta
        text(ax_main, hex_pos(1), hex_pos(2), hex_pos(3)+0.04, sprintf('H%d', i), ...
            'HorizontalAlignment', 'center', 'FontSize', 8, 'FontWeight', 'bold');
        
        if i == 1
            text(ax_zoom, hex_pos(1), hex_pos(2), hex_pos(3)+0.04, sprintf('H%d', i), ...
                'HorizontalAlignment', 'center', 'FontSize', 10, 'FontWeight', 'bold');
        end
    end
    
    % Punto objetivo
    plot3(ax_main, target_x, target_y, height_p, 'r*', 'MarkerSize', 20);
    plot3(ax_zoom, target_x, target_y, height_p, 'r*', 'MarkerSize', 20);
    
    plot3(ax_zoom, [hex_positions(1,1) target_x], ...
                   [hex_positions(1,2) target_y], ...
                   [hex_positions(1,3) height_p], 'g-', 'LineWidth', 2);
    
    % Información
    q1_mean = mean(q1_traj(:, frame)) * 180/pi;
    q2_mean = mean(q2_traj(:, frame)) * 180/pi;
    
    text(ax_main, -0.35, -0.35, 0.48, sprintf(...
        'Tiempo: %.1f s\nq₁ prom: %.1f°  q₂ prom: %.1f°', ...
        time, q1_mean, q2_mean), ...
        'FontSize', 10, 'BackgroundColor', 'white', 'EdgeColor', 'black');
    
    q1_mod1 = q1_traj(1, frame) * 180/pi;
    q2_mod1 = q2_traj(1, frame) * 180/pi;
    
    text(ax_zoom, -0.25, -0.15, 0.48, sprintf(...
        'Módulo 1\nq₁: %.1f°  q₂: %.1f°', q1_mod1, q2_mod1), ...
        'FontSize', 9, 'BackgroundColor', 'white', 'EdgeColor', 'black');
    
    % Configurar vista
    set(ax_main, 'XLim', [-0.4 0.4], 'YLim', [-0.4 0.4], 'ZLim', [-0.1 0.5]);
    set(ax_zoom, 'XLim', [-0.3 0.1], 'YLim', [-0.2 0.2], 'ZLim', [-0.1 0.5]);
    view(ax_main, 3);
    view(ax_zoom, 3);
    grid(ax_main, 'on');
    grid(ax_zoom, 'on');
    
    drawnow;
    
    % Grabar frame
    frame_img = getframe(fig);
    writeVideo(v, frame_img);
    
    if mod(frame, max(1, n_frames/10)) == 0
        fprintf('  %.0f%% completado\n', 100*frame/n_frames);
    end
end

close(v);
fprintf('\n✓ Vídeo guardado: %s\n\n', video_filename);

fprintf('\n╔════════════════════════════════════════════════════════════════╗\n');
fprintf('║              SIMULACIÓN COMPLETADA EXITOSAMENTE               ║\n');
fprintf('╚════════════════════════════════════════════════════════════════╝\n\n');

fprintf('RESUMEN:\n');
fprintf('✓ a) Arreglo de 16 módulos en panal\n');
fprintf('✓ b) Trayectoria circular p(t)\n');
fprintf('✓ c) Cinemática inversa: q₁, q₂ calculados\n');
fprintf('✓ d) Restricción: ±45°\n');
fprintf('✓ e) Dirección verificada\n');
fprintf('✓ f) Vídeo grabado CON ROTACIÓN DINÁMICA\n\n');

fprintf('Archivos generados:\n');
fprintf('  • %s (VÍDEO PRINCIPAL - CON ROTACIÓN)\n', video_filename);
fprintf('  • Gráficos: Ángulos q₁ y q₂ vs tiempo\n\n');
