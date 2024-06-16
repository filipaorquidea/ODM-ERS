#usei o video https://www.youtube.com/watch?v=fGRe4bHRoVo&list=PLGs0VKk2DiYyXlbJVaE8y1qr24YldYNDm&index=6
#pra usar python no vscode é precisoseguir esses passos:
# 1. Faça o download de python no site oficial: https://www.python.org
# 2. Faça o download da extensão de python para VScode 
# 3. Crie um novo arquivo python, ou nesse caso abra este
# 4. É necessário criar um ambiente virtual no VScode para python
# 5. Para criar o ambiente virtual vá ao terminal e execute o comando: python -m venv myenv (myenv é o nome que eu escolhi, mas pode ser qualquer um)
# 6. Depois para ativar o ambiente virtual é só usar isso:
#     .\venv\Scripts\activate       (vai basicamente rodar o script para ativar o virtual enviroment, que tá dentro da pasta já)
# 7. Para instalar opencv, numpy e mediapipe esse é o comando:
#     pip install opencv-python mediapipe numpy
#precisa ser feito no terminal do VSCode


#por alguma razão ainda desconhecida só tou a conseguir rodar o código pelo terminal e não com o ctrl + alt + n do vscode

#bibliotecas
import cv2
import mediapipe as mp
import numpy as np
import os
import serial


print(cv2.__version__)

#frame da webcam
width=1920
height=1080

#Carrega as imagens de sobreposição para as três poses
overlay_images = [
    cv2.imread("Silhueta_1.png", cv2.IMREAD_UNCHANGED),
    cv2.imread("Silhueta_2.png", cv2.IMREAD_UNCHANGED),
    cv2.imread("Silhueta_3.png", cv2.IMREAD_UNCHANGED)
]

#Converte as imagens para o formato RGBA
overlay_images = [cv2.cvtColor(img, cv2.COLOR_BGRA2RGBA) for img in overlay_images]

#Configura a comunicação serial
port = 'COM6'
baudrate = 9600
ser = serial.Serial(port, baudrate)


#essa parte é meio blackbox, eu peguei do stack overflow, o link está abaixo, mas não sei pq funciona assim
def overlay(frame, overlay_image, pos_x, pos_y):
    overlay_h, overlay_w = overlay_image.shape[:2]

    # isso aqui é pra ficar nas mesmas dimensões do frame, não percebo tudo pq peguei da internet, mas funciona
    # fonte: https://stackoverflow.com/questions/40895785/using-opencv-to-overlay-transparent-image-onto-another-image
    if pos_y + overlay_h > frame.shape[0]:
        overlay_h = frame.shape[0] - pos_y
        overlay_image = overlay_image[:overlay_h, :, :]

    if pos_x + overlay_w > frame.shape[1]:
        overlay_w = frame.shape[1] - pos_x
        overlay_image = overlay_image[:, :overlay_w, :]

    if overlay_h <= 0 or overlay_w <= 0:
        return frame
    
    overlay_color = overlay_image[:, :, :3]
    overlay_alpha = overlay_image[:, :, 3] / 255.0

    roi = frame[pos_y:pos_y + overlay_h, pos_x:pos_x + overlay_w]

    roi = roi * (1.0 - overlay_alpha[:, :, np.newaxis]) + overlay_color * overlay_alpha[:, :, np.newaxis]

    frame[pos_y:pos_y + overlay_h, pos_x:pos_x + overlay_w] = roi

    return frame

#camera object
cam=cv2.VideoCapture(0,cv2.CAP_DSHOW)
#Não sei muito bem pq, mas isso faz a webcam iniciar mais rapidamente, peguei desse site:
# https://toptechboy.com/faster-launch-of-webcam-and-smoother-video-in-opencv-on-windows/
cam.set(cv2.CAP_PROP_FRAME_WIDTH, width)
cam.set(cv2.CAP_PROP_FRAME_HEIGHT,height)
cam.set(cv2.CAP_PROP_FPS, 30)
cam.set(cv2.CAP_PROP_FOURCC,cv2.VideoWriter_fourcc(*'MJPG'))


#https://github.com/google-ai-edge/mediapipe/blob/master/docs/solutions/pose.md
# o tutorial que tou a seguir é esse: https://www.youtube.com/watch?v=jfVoR-g9Ca0&list=PLGs0VKk2DiYyXlbJVaE8y1qr24YldYNDm&index=38
pose = mp.solutions.pose.Pose(static_image_mode=False, model_complexity=1, enable_segmentation=False, min_detection_confidence=0.5, min_tracking_confidence=0.5)
#aparentemente precisa de um drawing object pra desenhar isso
mpDraw=mp.solutions.drawing_utils

#Pose 1, pontos que definem a pose
predefined_pose1 = {
    "LEFT_SHOULDER": (830, 320),
    "RIGHT_SHOULDER": (700, 300),
    "LEFT_ELBOW": (920, 340),
    "RIGHT_ELBOW": (650, 400),
    "LEFT_WRIST": (1100, 290),
    "RIGHT_WRIST": (560, 520),
    "LEFT_HIP": (840, 510),
    "RIGHT_HIP": (705, 530),
    "LEFT_KNEE": (910, 810),
    "RIGHT_KNEE": (750, 780),
    "LEFT_ANKLE": (950, 940),
    "RIGHT_ANKLE": (640, 900)
}

#Pose 2, pontos que definem a pose
predefined_pose2 = {
    "LEFT_SHOULDER": (890, 330),#feito
    "RIGHT_SHOULDER": (745, 250), #feito
    "LEFT_ELBOW": (1000, 380),#feito
    "RIGHT_ELBOW": (660, 210), #feito
    "LEFT_WRIST": (970, 500), #feito
    "RIGHT_WRIST": (735, 180), #feito
    "LEFT_HIP": (865, 510), #feito
    "RIGHT_HIP": (750, 530), #feito
    "LEFT_KNEE": (850, 760), #feito
    "RIGHT_KNEE": (790, 760), 
    "LEFT_ANKLE": (900, 940),
    "RIGHT_ANKLE": (880, 960)
}

#Pose 3, pontos que definem a pose
predefined_pose3 = {
    "LEFT_SHOULDER": (680, 320), #feito
    "RIGHT_SHOULDER": (810, 350), #feito
    "LEFT_ELBOW": (640, 230), #feito
    "RIGHT_ELBOW": (890, 425), #feito
    "LEFT_WRIST": (750, 130), #feito
    "RIGHT_WRIST": (960, 440), #feito
    "LEFT_HIP": (710, 510), #feito
    "RIGHT_HIP": (780, 480), #feito
    "LEFT_KNEE": (830, 730),
    "RIGHT_KNEE": (940, 470), #feito
    "LEFT_ANKLE": (800, 920),
    "RIGHT_ANKLE": (1050, 550), #feito
}


#Conexões entre os pontinhos (joints)
connections = [ 
    ("LEFT_SHOULDER", "LEFT_ELBOW"),
    ("RIGHT_SHOULDER", "RIGHT_ELBOW"),
    ("LEFT_SHOULDER", "RIGHT_SHOULDER"),
    ("LEFT_SHOULDER", "LEFT_HIP"),
    ("RIGHT_SHOULDER", "RIGHT_HIP"),
    ("LEFT_ELBOW", "LEFT_WRIST"),
    ("RIGHT_ELBOW", "RIGHT_WRIST"),
    ("LEFT_HIP", "RIGHT_HIP"),
    ("LEFT_HIP", "LEFT_KNEE"),
    ("LEFT_KNEE", "LEFT_ANKLE"),
    ("RIGHT_HIP", "RIGHT_KNEE"),
    ("RIGHT_KNEE", "RIGHT_ANKLE")
]

# Lista das poses predefinidas
predefined_poses = [
    predefined_pose1,
    predefined_pose2,
    predefined_pose3
]

pose_index = 0

# Diretórios para salvar imagens e dados
output_dir = "../ODM_data"
image_dir = os.path.join(output_dir, "imagens")

if not os.path.exists(output_dir):
    os.makedirs(output_dir)

#calcular distancia do utilizador para a pose
#isso aqui basicamente calcula a distância entre dois pontos
def calculate_distance(point1, point2):
    return np.linalg.norm(np.array(point1) - np.array(point2))

#função para verificar se a pose do usuário corresponde a uma das poses predefinidas
#pega até 100px de distancia e se tiver um ponto que faz match já aceita
def is_pose_matching(landmarks, predefined_pose, threshold=100):
    #match points inicial
    matched_joints = 0
    for joint_name, joint_pos in predefined_pose.items():
        if joint_name in landmarks:
            dist = calculate_distance(joint_pos, landmarks[joint_name])
            if dist < threshold:
                #aqui é definido o número de joints para fazer match, podemos aumentar isso
                matched_joints += 6
    return matched_joints >= 6 
    

# Função para salvar os pontos de referência da pose em um arquivo .dat
def save_to_dat_file(landmarks, filename):
    with open(filename, 'w') as file:
        for key, value in landmarks.items():
            file.write(f"{key}: {value[0]}, {value[1]}\n")

# Função para obter dados da porta serial
#retirei isso daqui: https://stackoverflow.com/questions/65632761/encode-ser-readline-as-utf-8
def get_serial_data():
    #propriedade do objeto serial (ser) que indica quantos bytes estão esperando para serem lidos 
    #se for maior que 0, significa que há dados disponíveis
   while ser.in_waiting > 0:
#converte os dados de bytes para uma string usando a codificação UTF-8
#o strip só remove os espaços em branco no início e fim da string
        myString = ser.readline().decode('utf-8').strip()
        #não sei pq esse if é assim, mas funcionou, peguei do exemplo acima
        if myString and myString[0] == 'U':
            userIdSplit = myString.split(' ')
            for i in range(1, 5):
                currentUser[i-1] = int(userIdSplit[i])
            return True
        return False       

currentUser = bytearray([0, 0, 0, 0])


#referencia https://www.youtube.com/watch?v=fGRe4bHRoVo&list=PLGs0VKk2DiYyXlbJVaE8y1qr24YldYNDm&index=6
while True:
    #ler camera
    ignore, frame = cam.read()
    frame=cv2.resize(frame,(width,height))
    #objeto do mediapipe pra analisar as coisas
    frameRGB=cv2.cvtColor(frame,cv2.COLOR_BGR2RGB)
    results=pose.process(frameRGB)
    #print(results)
    #criar array de landmarks que vão mostrar o x e o y
    landMarks={}
    #se tiver algo desenhar no frame normal, sem ser no frame RGB
    if results.pose_landmarks:
        #DESCOMENTAR CASO QUEIRA VER OS JOINTS DO USER
        #mpDraw.draw_landmarks(frame,results.pose_landmarks, mp.solutions.pose.POSE_CONNECTIONS)
        for idx, lm in enumerate(results.pose_landmarks.landmark):
            pos_x = int(lm.x * width)
            pos_y = int(lm.y * height)
            landMarks[mp.solutions.pose.PoseLandmark(idx).name] = (pos_x, pos_y)
            #DESCOMENTAR CASO QUEIRA VER OS PONTOS DO USER
           # cv2.circle(frame, (pos_x, pos_y), 5, (0, 255, 0), -1)


#Isso foi usado pra debug, ainda pode ser útil então vou deixar aqui
        #print(results.pose_landmarks)
        #landmarks tem um .x .y .z e .visibility
       # for lm in results.pose_landmarks.landmark:
            #print((lm.x, lm.y))
            #niiiiice tem o x e o y agoraaaaaa
            #hora de fazer append das coordenadas
            #pra fazer com que ele detecte o pixel multiplicamos pela width e height que foram definidos acima
            #tbm necessário forçar a transformação em int pq senão pode dar ruim
            #landMarks.append((int(lm.x*width),int(lm.y*height)))
            #agora dá valores de x e y
        #print(landMarks)

# Verifica se a pose detectada corresponde a uma pose pré-definida
        if is_pose_matching(landMarks, predefined_poses[pose_index]):
                # Gera um prefixo para o nome do arquivo baseado no ID do utilizador
                filename_prefix = ''.join(format(x, '02X') for x in currentUser[:2])
                dat_filename = f"{output_dir}/{filename_prefix}.dat"
                img_filename = f"{output_dir}/{filename_prefix}movimento.jpg"
                # Salva as coordenadas dos pontos chave em um arquivo .dat
                save_to_dat_file(landMarks, dat_filename)
                # Salva o frame atual como uma imagem .jpg
                cv2.imwrite(img_filename, frame)
                cv2.putText(frame, f"Pose {pose_index + 1} Matched!", (50, 50), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 3)
                #vai pra próxima pose
                pose_index = (pose_index + 1) % len(predefined_poses)                
        else:
            cv2.putText(frame, "Pose Not Matched", (50, 50), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 3)

   # Verifica se há dados recebidos pela porta serial
    if get_serial_data():
        print(f"Received user data: {list(currentUser)}")
        
# Desenha os pontos chave da pose pré-definida atual
    #for joint_name, joint in predefined_poses[pose_index].items():
        #cv2.circle(frame, joint, 5, (0, 0, 255), -1)
        #cv2.putText(frame, joint_name, (joint[0] + 10, joint[1] - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 2)

# Desenha as conexões entre os pontos da pose atual
    for connection in connections:
        if connection[0] in predefined_poses[pose_index] and connection[1] in predefined_poses[pose_index]:
            joint1 = predefined_poses[pose_index][connection[0]]
            joint2 = predefined_poses[pose_index][connection[1]]
            #cv2.line(frame, joint1, joint2, (255, 0, 0), 2)

 # Aplica o overlay ao frame
    frame = overlay(frame, overlay_images[pose_index], pos_x=100, pos_y=100)
        
    #mostrar camera
    cv2.imshow('minha WEBcam', frame)
    #cv2.imshow('Predefined Pose', pose_image)
    cv2.moveWindow('minha WEBcam',0,0)
    #pra fechar a camera, wait for 1 ms e se apertou 'q'
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    #APERTA Q PRA SAIR NÃO DÁ PRA FECHAR SEM APERTAR Q!!!!!
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    if cv2.waitKey(1) & 0xff ==ord('q'):
        break
cam.release()
cv2.destroyAllWindows()
ser.close()