import processing.serial.*;


Serial microbit;


/*
センサーデータを表すクラス

メンバ変数
  m_name : センサーの名前
  m_max : センサーの最大値
  m_min : センサーの最小値
  m_values : センサーデータ

メソッド
  update(value) : センサーデータの最後尾にvalueの値を追加
  draw_data(x,y) : センサー名、最新のセンサーデータ、データの時間変化のグラフを描画
*/
class SensorData{
  String m_name;
  float m_max;
  float m_min;
  float[] m_values;

  SensorData(String name,float _max, float _min){
    m_name = name;
    m_max = _max;
    m_min = _min;
    m_values = new float[100];
  }

  void update(int value){
    if (value > m_max){
      m_values = append(subset(m_values, 1), m_max);
    }else if (value < m_min){
      m_values = append(subset(m_values, 1), m_min);
    }else{
      m_values = append(subset(m_values, 1), float(value));
    }

  }

  void draw_data(float x, float y){
    float data = 0;
    float graph_height = (height / 3 - 20);
    float graph_width = (width / 3 - 20) / m_values.length;
    text(m_name + " : " + str(m_values[99]),x+4,y+5);
    for (int i = 0; i < m_values.length - 1; i++) {
      line(x + i * graph_width + 10, y + (1.0 - (m_values[i] - m_min) / (m_max - m_min)) * graph_height + 10, x + (i + 1) * graph_width + 10, y + (1.0 - (m_values[i+1] - m_min) / (m_max - m_min)) * graph_height + 10);
    }
  }
}


SensorData button_a = new SensorData("Button A", 1.0, 0.0);
SensorData button_b = new SensorData("Button B", 1.0, 0.0);
SensorData temp = new SensorData("Tempreture", 50.0, -5.0);
SensorData brightness = new SensorData("Brightness", 256.0, 0.0);
SensorData compass = new SensorData("Compass", 360.0, 0.0);
SensorData rotation = new SensorData("rotation pitch", 360.0, 0.0);
SensorData acc_x = new SensorData("Accceleration X", 1024.0, -1024.0);
SensorData acc_y = new SensorData("Accceleration Y", 1024.0, -1024.0);
SensorData acc_z = new SensorData("Accceleration Z", 1024.0, -1024.0);

SensorData[] sensor_lst = {button_a, button_b, temp, brightness, compass, rotation, acc_x, acc_y, acc_z};

float angle = 0;

// シリアル通信で受け取ったデータの処理
void serialEvent(Serial microbit) {
  if (microbit.available() > 0) {
    try {
      String input = microbit.readStringUntil('\n');
      if (input != null) {
        input = trim(input);
        String [] data = split(input, ' ');
        for (int i = 0; i < sensor_lst.length; i++) {
          sensor_lst[i].update(int(data[i+1]));
        }
      }
    } catch (RuntimeException e) {
      println("RuntimeException!!");
    }
  }
}


// 初期化を行う関数
void setup() {
  size(1280, 720); // windowサイズを定義

  // シリアル通信関連の初期化処理
  for (int i = 0; i < Serial.list().length; i++) {
      println(i + ": " + Serial.list()[i]);
  }
  String portName = "/dev/cu.usbmodem14602";
  println(portName);
  try {
    microbit = new Serial(this, portName, 115200);
    microbit.clear();
    microbit.bufferUntil(10);
    println("Success");
  } catch (Exception e) {
    println("ERROR");
    super.exit();
  }


  // 文字描画の設定
  PFont font = createFont("YuGo-Bold",48,true);
  textFont(font,48);
  textAlign(LEFT, TOP);
  textSize(20);
  fill(10);
}


// ウィンドウ全体の描画処理
void draw(){
  background(255);
  angle += 0.05;

  // 画面を9分割する線をひく
  line(width / 3, 0, width / 3, height);
  line(2 * width / 3, 0, 2 * width / 3, height);
  line(0, height / 3, width, height / 3);
  line(0, 2 * height / 3, width, 2 * height / 3);

  serialEvent(microbit);

  // それぞれのセンサーの数値やグラフを描画する関数を実行
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      sensor_lst[i*3+j].draw_data(j * width / 3, i * height / 3);
    }
  }
}
