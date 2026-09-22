# Auditoría de Corte 1 - sOFIa

**Versión de trabajo:** v0.2 - 2026-09-21

## Estado frente a la lista de cotejo

| Elemento | Estado v0.2 | Observación |
|---|---|---|
| Title / Authors | CUMPLE EN BORRADOR | Se sustituyó `Title` por un título técnico coherente con el alcance actual. Lista de autores conservada. |
| Abstract / Index Terms | CUMPLE EN BORRADOR | Abstract provisional y 6 keywords. Debe actualizarse cuando existan resultados finales. |
| Author Contributions | PENDIENTE DE DATOS DEL EQUIPO | No se inventaron contribuciones individuales. |
| Data Availability | PARCIAL | Ya existe una declaración, pero falta URL/identificador del repositorio. |
| Acknowledgment | PARCIAL | Se reconoce LabDST; falta acordar la declaración final de uso de IA y apoyos adicionales. |
| Conflicts of Interest | PENDIENTE DE CONFIRMACIÓN | No se asumió una declaración por los autores. |
| Introduction | CUMPLE EN PRIMER BORRADOR | Incluye contexto, problema, pregunta rectora, objetivo y alcance del Corte 1. |
| Related Work | CUMPLE EN PRIMER BORRADOR | Se conservan OpenPose, MediaPipe/BlazePose y YOLO11 como referentes; MediaPipe queda claramente identificado como la tecnología seleccionada en el prototipo actual. |
| Comprensión del referente | CUMPLE | Se explica el flujo cámara -> landmarks -> gesto -> mapeo de 16 módulos -> ESP32 -> movimiento, además de la arquitectura distribuida. |
| Requerimientos | CUMPLE | Tabla FR1-FR6 trazada a la especificación del proyecto. |
| Vocabulario de 5 gestos | CUMPLE | Se documentan tres gestos dinámicos y dos estáticos sostenidos, junto con la reacción mecánica prevista para cada uno. |
| Adquisición de métricas de visión | CUMPLE COMO MÉTODO | El software ya contempla CSV con timestamp, FPS, número de manos, gesto, confianza y latencia; los resultados medidos se reservan para Results. |
| Selección tecnológica | CUMPLE | MediaPipe + OpenCV + NumPy quedan documentados como baseline implementado; OpenPose, YOLO11 y OpenCV DNN se mantienen como alternativas de comparación. |
| BOM sin costo | PARCIAL | Se añadió tabla resumida. Faltan número de parte, fabricante/localidad verificados para varios renglones. |
| Arquitectura preliminar | CUMPLE | Se documentan captura desacoplada, inferencia, suavizado por mano, asociación opcional mano-persona, motor de gestos, mapeo 16 módulos, limitador de slew y enlace con ESP32. |
| Riesgos y mitigación | CUMPLE | Se añadió registro de riesgos: ruido, cámara, comunicación, saturación, singularidad y multiusuario. |
| Modelo matemático | CUMPLE | Se documentaron R_x(q1)R_y(q2), dirección del efector e inversa con arcsin/atan2. |
| Microprueba | CUMPLE METODOLÓGICAMENTE | Se documentan la simulación MATLAB y el plan de micropruebas de visión con registro de FPS, latencia, manos detectadas, gesto y confianza. |
| GitHub / versión | NO VERIFICABLE DESDE EL ZIP | El `.tex` ya incluye v0.2; el equipo registrará commit/tag al subirlo al repositorio. |
| Bitácora | NO VERIFICABLE | Debe existir evidencia equivalente en la bitácora del equipo. |

## Correcciones técnicas importantes realizadas

1. **Orden de rotación:** el material de modelado define `R = Rx(q1) Ry(q2)`. El script original visualizaba con `R = Ry(q2) Rx(q1)`. Se corrigió el orden en `motionHexArray_Corte1_corrected.m`.
2. **Verificación angular:** el script original comparaba el vector objetivo normalizado contra una copia de sí mismo, por lo que el error reportado no validaba la orientación obtenida. Se sustituyó por la reconstrucción de `r_hat_23` a partir de los ángulos limitados y se calcula el error angular contra la dirección deseada.
3. **Singularidad:** se añadió manejo explícito del caso `u_x = +/-1`, conservando el último `q1` válido (o 0 al inicializar).
4. **LaTeX:** se cambió `algorithmic` por `algpseudocode`, eliminando los errores de compilación de `\Require`, `\Ensure`, `\State`, `\If`, etc.
5. **Plantilla:** se eliminó del documento visible todo el texto instructivo de la plantilla y los placeholders de Results/Discussion/Conclusions que todavía no corresponden al Corte 1.
6. **Bibliografía:** se eliminaron las referencias placeholder y se agregaron fuentes reales para OpenPose, MediaPipe, BlazePose, YOLO11, PCA9685, ESP32-C3 y los documentos técnicos internos usados.
7. **Visión integrada:** se sustituyó la interpretación anterior de YOLO como baseline por la implementación real MediaPipe + OpenCV + NumPy; se añadieron los cinco gestos, su reacción, el pipeline multihilo, suavizado, asociación multiusuario, mapeo de 16 módulos, comunicación y formato de adquisición de métricas.

## Información que todavía necesita confirmación del equipo

- **Números de parte, fabricante y localidad** verificados del BOM real, especialmente MG90S, RS-485, LED, JST-VH y PCB/ensamble.
- **Roles/contribuciones por integrante** para Author Contributions.
- URL o identificador del **repositorio GitHub** para Data Availability y trazabilidad de versión.
- Confirmación del texto final para **Conflicts of Interest** y **Acknowledgment/uso de IA**.
- Fijar en el repositorio las **versiones exactas de Python y dependencias** usadas por la implementación de visión, porque los documentos internos actualmente registran versiones menores distintas.

En cuanto a contenido técnico del Corte 1, `Introduction (+ Related Work)` y `Materials and Methods` ya contienen el apartado de visión, los cinco gestos, arquitectura preliminar, métricas previstas, cinemática, microprueba y riesgos. Los puntos anteriores son principalmente de trazabilidad, BOM y cierre editorial.

## Siguiente prioridad recomendada

1. Verificar BOM y trazabilidad de los componentes pendientes.
2. Completar Author Contributions, Data Availability, Acknowledgment y Conflicts of Interest.
3. Fijar versiones de dependencias en GitHub y registrar la versión/commit del Corte 1.
4. Regenerar la simulación con el MATLAB corregido y sustituir `s1-s4` por capturas nuevas si se desea dejar la evidencia visual totalmente consistente con la corrección matemática.
5. Ejecutar una última revisión editorial de inglés antes de la entrega.
