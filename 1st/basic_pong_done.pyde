# Declaremos todas las variables
positionX, positionY, movementX, movementY, first_time, up, down, up2, down2, life1, life2, score1, score2 = 40, 200, 3, 4, True, False, False, False, False, 3, 3, 0, 0
'''
    Acabamos de establecer:
    1. La posición determinada para el spawn de la bola (se puede hacer aleatorio).
    2. Tazas de movimiento para la pelota en cada eje.
    3. Estructura de control "primera vez" para asignarle algunos atributos a la raqueta (rectángulo) usando ámbitos creados por draw.

    Podemos establecer la posición de los rectángulos para las raquetas, pero sin las palabras width que solo existen cuando se ejecuta el draw.
'''

def setup():
    size(600,400) # Tamaño del lienzo

def draw():
    background(0) # Fondo negro
    # Para usar las variables que declaramos antes usamos global
    global positionX, positionY, movementX, movementY, rec_width, rec_positionY, first_time, up, down, up2, down2, life1, life2, score1, score2
    font = loadFont("Mi fuente.vlw")
    textFont(font, 24)

    # Game over
    fill(255, 0, 0) # Rojo

    if life1 == 0:
        text("Ha perdido el jugador del lado izquierdo", width / 2 - 175, height / 2)
        noLoop()
        fill(0, 0, 255) # Azul
    elif life2 == 0:
        text("Ha perdido el jugador del lado derecho", width / 2 - 175, height / 2)
        noLoop()

    rec_width = 20
    rec_height  = rec_width * 4

    # Texto de vidas
    life1 = str(life1)
    life2 = str(life2)
    score1 = str(score1)
    score2 = str(score2)

    fill(255)
    text("Vidas: " + life1 , 10, 50         )
    text("Vidas: " + life2 , width - 120, 50)
    text("Score: " + score1, 10, 70         )
    text("Score: " + score2, width - 120, 70)

    if first_time:
        global rec_positionY
        global rec_positionY2
        global first_time
        rec_positionY  = width / 2  - rec_height / 2 # Para que los rectángulos aparezcan alineados verticalmente (teniendo en cuenta que tienen una altura)
        rec_positionY2 = width / 2  - rec_height / 2
        first_time   = False

    diameter = 40
    radius = diameter / 2
    fill(255) # Blanco
    ellipse(positionX         , positionY     , diameter , diameter  )
    rect(5                    , rec_positionY , rec_width, rec_height) # 5 pixeles del borde
    rect(width - rec_width - 5, rec_positionY2, rec_width, rec_height) # Debido al control de las coordenadas es 575 (width - rec_width - 5) en vez de 595
    fill(255)

    # //----- Decoraciones -----//
    noStroke() # Quitar delineado
    # Recordando que rect(xInicial, yInicial, xFinal, yFinal)
    fill(255, 0, 0) # Rojo
    # Aprovechamos el 5 que dejamos de margen entre los border y las "raquetas"
    rect(0,          0,         5, height) # Izquierda
    rect(5, height - 5, width / 2,      5) # Abajo
    rect(5,          0, width / 2,      5) # Arriba
    fill(0, 0, 255) # Azul
    rect(width / 2,          0, width,      5) # Arriba
    rect(width - 5,          0,     5, height) # Derecha
    rect(width / 2, height - 5, width,      5) # Abajo

    # En la pelota
    # Aplicamos las tazas de movimiento que establecimos antes
    positionX += movementX
    positionY += movementY
    # Con la tazas aplicadas vamos cambiando las posiciones de las variables

    # //----- Rebote horizontal y vidas -----//
    if positionX > width - radius or positionX < radius:
        if movementX > 0:
            movementX += 0.2
        else:
            movementX -= 0.2

        movementX = -movementX # Cambiamos la dirección

        if positionX < 50:
            life1 -= 1
        else:
            life2 -= 1

    # Rebote vertical
    if positionY > height - 5 - radius or positionY < radius - 5:
        movementY = -movementY

    # Movimiento raqueta izquierda
    if up and rec_positionY > 0:
        rec_positionY -= 3
    elif down and rec_positionY < height - rec_height:
        rec_positionY += 3

    # Movimiento raqueta derecha
    if up2 and rec_positionY2 > 0:
        rec_positionY2 -= 3
    elif down2 and rec_positionY2 < height - rec_height:
        rec_positionY2 += 3

    # //----- Rebote raquetas -----//
    # Raqueta izquierda
    if positionX <= 5 + rec_width + radius and movementX < 0:
        if positionY >= rec_positionY and positionY <= rec_positionY + rec_height: # Izquierda = movimiento negativo
            movementX -=0.2
            movementX = -movementX
            score1 += 25
    # Raqueta derecha
    elif positionX >= 575 - radius and movementX > 0:
        if positionY >= rec_positionY2 and positionY <= rec_positionY2 + rec_height:
            movementX += 0.2
            movementX = -movementX
            score2 += 25

def keyPressed():
    global up, down, up2, down2
    if keyCode == UP:
        up = True
    elif keyCode == DOWN:
        down = True
    elif key == "w":
        up2 = True
    elif key == "s":
        down2 = True

def keyReleased():
    global up, down, up2, down2
    if keyCode == UP:
        up = False
    elif keyCode == DOWN:
        down = False
    elif key == "w":
        up2 = False
    elif key == "s":
        down2 = False