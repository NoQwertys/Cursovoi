unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.AppEvnts, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.Imaging.jpeg, math, System.ImageList,
  Vcl.ImgList, Vcl.Imaging.pngimage, Vcl.MPlayer;

type
  TForm1 = class(TForm)
    Player: TShape;
    TimerPlayer: TTimer;
    ApplicationEvents1: TApplicationEvents;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    check: TTimer;
    create: TTimer;
    left: TTimer;
    create2: TTimer;
    leftANDright: TTimer;
    clear: TTimer;
    MainText: TLabel;
    LVL1_5sec: TTimer;
    LVL1_2_5sec: TTimer;
    LVL2_move: TTimer;
    LVL2_create: TTimer;
    LVL2_createS: TTimer;
    Image7: TImage;
    back: TImage;
    LVL3_create: TTimer;
    LVL3_move: TTimer;
    wasd: TImage;
    Label1: TLabel;
    Label2: TLabel;
    win: TImage;
    lose: TImage;
    winT: TTimer;
    loseT: TTimer;
    LVL2_create2: TTimer;
    LVL2_3sec: TTimer;
    LVL3_3sec: TTimer;
    LVL4_3sec: TTimer;
    LVL5_3sec: TTimer;
    LVL4_create: TTimer;
    LVL4_3sec2: TTimer;
    LVL4_create2: TTimer;
    LVL4_create3: TTimer;
    LVL5_create: TTimer;
    LVL5_create2: TTimer;
    MPlayer: TMediaPlayer;
    procedure TimerPlayerTimer(Sender: TObject);
    procedure ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure checkTimer(Sender: TObject);
    procedure createTimer(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure create2Timer(Sender: TObject);
    procedure leftANDrightTimer(Sender: TObject);
    procedure clearTimer(Sender: TObject);
    procedure leftTimer(Sender: TObject);
    procedure LVL1_5secTimer(Sender: TObject);
    procedure LVL1_2_5secTimer(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure LVL2_createTimer(Sender: TObject);
    procedure LVL2_moveTimer(Sender: TObject);
    procedure LVL2_createSTimer(Sender: TObject);
    procedure Image7Click(Sender: TObject);
    procedure backClick(Sender: TObject);
    procedure LVL3_moveTimer(Sender: TObject);
    procedure LVL3_createTimer(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure Image6Click(Sender: TObject);
    procedure winTTimer(Sender: TObject);
    procedure loseTTimer(Sender: TObject);
    procedure LVL2_create2Timer(Sender: TObject);
    procedure LVL2_3secTimer(Sender: TObject);
    procedure LVL3_3secTimer(Sender: TObject);
    procedure LVL4_3secTimer(Sender: TObject);
    procedure LVL5_3secTimer(Sender: TObject);
    procedure LVL4_createTimer(Sender: TObject);
    procedure LVL4_create2Timer(Sender: TObject);
    procedure LVL4_3sec2Timer(Sender: TObject);
    procedure LVL4_create3Timer(Sender: TObject);
    procedure LVL5_createTimer(Sender: TObject);
    procedure LVL5_create2Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

   private
    { Private declarations }
    Timers: array of TTimer;
    procedure DeathPlayer;
    procedure DisableAllTimers;
    procedure normalaz;

  public
    { Public declarations }
  end;

const
  WM_KEYDOWN = $0100;
  WM_KEYUP = $0101;
var
  PlayerSpeed:integer; // скорость игрока
  Pspeed:integer=10;
  EnemySpeed:integer = 16;
  Form1: TForm1;
  PlayerX: Integer; // Координаты игрока
  PlayerY: Integer; // Координаты игрока
  MoveVector: TPoint;
  IsMovingUp, IsMovingDown, IsMovingLeft, IsMovingRight, IsSpace: Boolean; // Флаги направления движения
  b,c,d:integer;
  progres_point:integer;
  F: Textfile;
  Enemies: array of TShape;
  Enemies2: array of TShape;
  Square: TShape;

implementation

{$R *.dfm}

uses Unit2;

procedure Media(text:string);
begin
  form1.MPlayer.FileName := text;
  form1.MPlayer.Open;
  form1.MPlayer.play;
end;

procedure TForm1.ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
begin
  if (Msg.message = WM_KEYDOWN) or (Msg.message = WM_KEYUP) then
  begin
    case Msg.wParam of
      Ord('W'), Ord('w'):
        begin
          if Msg.message = WM_KEYDOWN then
            IsMovingUp := True
          else
            IsMovingUp := False;
        end;
      Ord('A'), Ord('a'):
        begin
          if Msg.message = WM_KEYDOWN then
            IsMovingLeft := True
          else
            IsMovingLeft := False;
        end;
      Ord('S'), Ord('s'):
        begin
          if Msg.message = WM_KEYDOWN then
            IsMovingDown := True
          else
            IsMovingDown := False;
        end;
      Ord('D'), Ord('d'):
        begin
          if Msg.message = WM_KEYDOWN then
            IsMovingRight := True
          else
            IsMovingRight := False;
        end;
      32:
        begin
          if Msg.message = WM_KEYDOWN then
            IsSpace := true
          else
            IsSpace := False;
        end;
    end;
  end;
end;

// функция проверки столкновения
function CheckCollision(X1, Y1, Width1, Height1, X2, Y2, Width2, Height2: Integer): Boolean;
begin
  Result := (X1 < X2 + Width2) and (X1 + Width1 > X2) and
            (Y1 < Y2 + Height2) and (Y1 + Height1 > Y2);
end;

procedure TForm1.TimerPlayerTimer(Sender: TObject);
begin //движение игрока
  MoveVector := Point(0, 0);
  PlayerSpeed:=Pspeed;
  if IsMovingUp then
    MoveVector.Y := MoveVector.Y - 1;
  if IsMovingLeft then
    MoveVector.X := MoveVector.X - 1;
  if IsMovingDown then
    MoveVector.Y := MoveVector.Y + 1;
  if IsMovingRight then
    MoveVector.X := MoveVector.X + 1;

   // границы для игрока
   if Player.top < 1 then
    MoveVector.Y := MoveVector.Y+1;
   if Player.Left < 1 then
     MoveVector.X:=MoveVector.X+1;
   if Player.top+52 > Form1.Height then
     MoveVector.Y:=MoveVector.Y-1;
   if Player.Left+50 > Form1.Width then
    MoveVector.X := MoveVector.X-1;

   if (IsMovingUp and IsMovingLeft) or (IsMovingUp and IsMovingRight) or
    (IsMovingDown and IsMovingLeft) or (IsMovingDown and IsMovingRight)
    then PlayerSpeed:=Round(PlayerSpeed*0.7);

  PlayerX := PlayerX + (MoveVector.X * PlayerSpeed);
  PlayerY := PlayerY + (MoveVector.Y * PlayerSpeed);

  // Обновляем позицию игрока на форме
  Player.Left := PlayerX;
  Player.Top := PlayerY;
end;

procedure TForm1.checkTimer(Sender: TObject);
var
I: Integer;
begin
  if not (MPlayer.Mode = mpPlaying) then
  Media('04.mp3');

  if image1.Visible	 then
  begin
    label2.Visible:=true;
    image2.Visible:=false;
    image3.Visible:=false;
    image4.Visible:=false;
    image5.Visible:=false;
    image6.Visible:=false;
  end
  else
     label2.Visible:=false;

  for I := 0 to Length(Enemies) - 1 do
  begin
    // Проверка столкновения врага с игроком
    if CheckCollision(PlayerX, PlayerY, Player.Width, Player.Height,
      Enemies[I].Left, Enemies[I].Top, Enemies[I].Width, Enemies[I].Height) then
      begin
        normalaz;
        loseT.Enabled :=true;
        lose.Visible :=true;
        Media('lose.mp3');
      end;
  end;
  for I := 0 to Length(Enemies2) - 1 do
  begin
    if CheckCollision(PlayerX, PlayerY, Player.Width, Player.Height,
      Enemies2[I].Left, Enemies2[I].Top, Enemies2[I].Width, Enemies2[I].Height) then
      begin
        normalaz;
        loseT.Enabled :=true;
        lose.Visible :=true;
        Media('lose.mp3');
      end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin

  label2.Caption:=
  'Цель игры:' + #13#10 +
  '  Пройти все уровни, уворачиваясь от врагов' + #13#10 +
  'Правила игры:' + #13#10 +
  '  Синий - игрок' + #13#10 +
  '  Красный - враг' + #13#10 +
  '  На уровень одна жизнь'+ #13#10 +
  '  Пройденный уровень сохраняется'+ #13#10 +
  'Доп. информация:' + #13#10 +
  '  Первые три уровня обучение'+ #13#10 +
  '  Play - перейти к уровням'+ #13#10 +
  '  Exit - выйти с игры'+ #13#10 +
  '  Стрелка назад - вернутся назад';
  PlayerX:=  round(Screen.Width/2);
  PlayerY:=  round(Screen.Height/2);
  Form1.WindowState:=wsMaximized;
  Form1.BorderStyle:=bsNone;
  Form1.Width:=Screen.Width;
  Form1.height:=Screen.Height;

  AssignFile(F, 'progres_point.txt');
  Reset(F);
  Readln(F,progres_point);
  closefile(F);

  case progres_point of
    1: begin
        Image3.Picture.LoadFromFile('2.jpg');
    end;
    2: begin
       Image3.Picture.LoadFromFile('2.jpg');
       Image4.Picture.LoadFromFile('3.jpg');
    end;
    3: begin
       Image3.Picture.LoadFromFile('2.jpg');
       Image4.Picture.LoadFromFile('3.jpg');
       Image5.Picture.LoadFromFile('4.jpg');
    end;
    4: begin
       Image3.Picture.LoadFromFile('2.jpg');
       Image4.Picture.LoadFromFile('3.jpg');
       Image5.Picture.LoadFromFile('4.jpg');
       Image6.Picture.LoadFromFile('5.jpg');
    end;
  end;

  // Массив таймеров
  SetLength(Timers,22);
  Timers[0] := create;
  Timers[1] := left;
  Timers[2] := create2;
  Timers[3] := leftANDright;
  Timers[4] := TimerPlayer;
  Timers[5] := LVL1_5sec;
  Timers[6] := LVL1_2_5sec;
  Timers[7] := LVL2_create;
  Timers[8] := LVL2_create2;
  Timers[9] := LVL2_createS;
  Timers[10] := LVL2_3sec;
  Timers[11] := LVL2_move;
  Timers[12] := LVL3_create;
  Timers[13] := LVL3_move;
  Timers[14] := LVL4_create;
  Timers[15] := LVL4_create2;
  Timers[16] := LVL4_create3;
  Timers[17] := LVL4_3sec;
  Timers[18] := LVL4_3sec2;
  Timers[19] := LVL5_create;
  Timers[20] := LVL5_create2;
  Timers[21] := LVL5_3sec;
end;

// отключение всех таймеров
procedure TForm1.DisableAllTimers;
var
  i: Integer;
begin
  for i := Low(Timers) to High(Timers) do
  begin
    Timers[i].Enabled := False;
  end;
end;

procedure TForm1.Image1Click(Sender: TObject);
begin
  image1.Visible:=false;
  image2.Visible:=true;
  image3.Visible:=true;
  image4.Visible:=true;
  image5.Visible:=true;
  image6.Visible:=true;
  image7.Visible:=false;
  back.Visible:=true;
  label2.Visible :=false;

end;

procedure TForm1.Image7Click(Sender: TObject);
begin
application.Terminate;
end;

procedure TForm1.backClick(Sender: TObject);
begin
   if TimerPlayer.Enabled	 then
   begin
    Media('lose.mp3');
    normalaz;
    loseT.Enabled :=true;
    lose.Visible :=true;
    wasd.Visible :=false;
    label1.Visible :=false;
   end
   else
   begin
    image1.Visible:=true;
    image2.Visible:=false;
    image3.Visible:=false;
    image4.Visible:=false;
    image5.Visible:=false;
    image6.Visible:=false;
    image7.Visible:=true;
    back.Visible:=false;
    wasd.Visible :=false;
    label1.Visible :=false;
    normalaz;
   end;
end;

procedure TForm1.DeathPlayer;
begin
        image2.Visible:=true;
        image3.Visible:=true;
        image4.Visible:=true;
        image5.Visible:=true;
        image6.Visible:=true;
end;

procedure Tform1.normalaz;
begin
        MainText.Caption:='';
        player.Visible:=false;
        DisableAllTimers;
        clear.Enabled:=true;
        b:=0;
        PlayerX:=  round(Screen.Width/2);
        PlayerY:=  round(Screen.Height/2);
end;

procedure TForm1.winTTimer(Sender: TObject);
begin
    DeathPlayer;
    win.Visible :=false;
    winT.Enabled :=false;
end;

procedure TForm1.loseTTimer(Sender: TObject);
begin
    DeathPlayer;
    lose.Visible :=false;
    loseT.Enabled :=false;
end;

// проверка нажатия уровня
procedure TForm1.Image2Click(Sender: TObject);
begin
        Media('08.mp3');
        MainText.Caption:=
        '                           [Уровень 1]' + #13#10 + 
        'Круги - враги, которые движутся по прямой';
        image2.Visible:=false;
        image3.Visible:=false;
        image4.Visible:=false;
        image5.Visible:=false;
        image6.Visible:=false;
        LVL1_5sec.Enabled:=true;
        player.Visible:=true;
        TimerPlayer.Enabled:=true;
        wasd.visible :=true;
        label1.Visible :=true;
end;

procedure TForm1.Image3Click(Sender: TObject);
begin
      if progres_point > 0 then
      begin
        Media('08.mp3');
        MainText.Caption:=
                '                           [Уровень 2]' + #13#10 + 
        'Квадраты - враги, создающие вокруг себя круги';
        image2.Visible:=false;
        image3.Visible:=false;
        image4.Visible:=false;
        image5.Visible:=false;
        image6.Visible:=false;
        player.Visible:=true;
        TimerPlayer.Enabled:=true;
        Lvl2_create.Enabled:=true;
        Lvl2_move.Enabled:=true;
      end;
end;

procedure TForm1.Image4Click(Sender: TObject);
begin
      if progres_point > 1 then
      begin
        Media('08.mp3');
                MainText.Caption:=
                '                           [Уровень 3]' + #13#10 + 
        'Квадратики - враги, которые приследуют тебя';
        image2.Visible:=false;
        image3.Visible:=false;
        image4.Visible:=false;
        image5.Visible:=false;
        image6.Visible:=false;
        player.Visible:=true;
        TimerPlayer.Enabled:=true;
        LVL3_3sec.Enabled:=true;
      end;
end;

procedure TForm1.Image5Click(Sender: TObject);
begin
      if progres_point > 2 then
      begin
      Media('011.mp3');
        MainText.Caption:=
                '                           [Уровень 4]';
        image2.Visible:=false;
        image3.Visible:=false;
        image4.Visible:=false;
        image5.Visible:=false;
        image6.Visible:=false;
        player.Visible:=true;
        TimerPlayer.Enabled:=true;
        LVL4_3sec.Enabled	:=true;
        LVL4_3sec2.Enabled:=true;
      end;
end;

procedure TForm1.Image6Click(Sender: TObject);
begin
      if progres_point > 3 then
      begin
        Media('06.mp3');
        MainText.Caption:=
                '                           [Уровень 5]';
        image2.Visible:=false;
        image3.Visible:=false;
        image4.Visible:=false;
        image5.Visible:=false;
        image6.Visible:=false;
        player.Visible:=true;
        TimerPlayer.Enabled:=true;
        LVL5_3sec.Enabled	:=true;
      end;
end;

// ===================================level 1=====================================

procedure TForm1.LVL1_5secTimer(Sender: TObject);
begin
        MainText.Caption:='';
        left.Enabled:=true;
        create.Enabled:=true;
        wasd.visible :=false;
        label1.Visible :=false;
        LVL1_5sec.Enabled:=false;
end;

// создание врагов кругов
procedure CreateEnemy(AForm: TForm; postop,posleft:integer; direction:integer=0);
var
  Enemy: TShape;
begin
  Enemy := TShape.Create(AForm);
  Enemy.Parent := AForm;
  Enemy.Shape := stCircle;
  Enemy.Brush.Color := clRed;
  Enemy.Width := 40;
  Enemy.Height := 40 ;
  Enemy.Left := posleft;  // Начальная позиция
  Enemy.Top := postop;
  SetLength(Enemies, Length(Enemies) + 1);
  Enemies[Length(Enemies) - 1] := Enemy;
    case direction of
    1: Enemy.Tag := 1;  // Движение влево
    2: Enemy.Tag := 2;  // Движение вправо
    3: Enemy.Tag := 3;  // Движение вверх
    4: Enemy.Tag := 4;  // Движение вниз
  end;
end;

procedure TForm1.createTimer(Sender: TObject);
begin
  begin
    if b>Screen.Height+100 then
      begin
        create.Enabled:=false;
        left.Enabled:=false;
        clear.Enabled:=true;
        MainText.Caption:='                 А теперь посложнее';
        LVL1_2_5sec.Enabled:=true;
        b:=0;
      end;
    b:=b+100;
    CreateEnemy(Self,b,Form1.ClientWidth);
  end;
end;

procedure TForm1.leftTimer(Sender: TObject);
begin
var
  I: Integer;
  for I := 0 to Length(Enemies) - 1 do
    Enemies[I].Left := Enemies[I].Left - EnemySpeed;
end;

procedure TForm1.clearTimer(Sender: TObject);
begin
  for var I := 0 to Length(Enemies) - 1 do
    Enemies[I].free;
  SetLength(Enemies, 0);
  clear.Enabled:=false;

  for var I := 0 to Length(Enemies2) - 1 do
    Enemies2[I].free;
  SetLength(Enemies2, 0);
  clear.Enabled:=false;
end;

procedure TForm1.LVL1_2_5secTimer(Sender: TObject);
begin
    create2.Enabled:=true;
    leftANDright.Enabled:=true;
    MainText.Caption:='';
    LVL1_2_5sec.Enabled:=false;
end;

procedure TForm1.create2Timer(Sender: TObject);
begin
  if b>Screen.Height+400 then
    begin
      Image3.Picture.LoadFromFile('2.jpg');
      if progres_point < 1 then
      begin
        progres_point:=1;
        AssignFile(F, 'progres_point.txt');
        Rewrite(F);
        write(F,progres_point);
        Closefile(F);
      end;
      Media('win.mp3');
      normalaz;
      winT.Enabled :=true;
      win.Visible :=true;

    end;
  b:=b+100;
  CreateEnemy(Self,b,Form1.ClientWidth);
  CreateEnemy(Self,b,0);
end;

procedure TForm1.leftANDrightTimer(Sender: TObject);
begin
 var
  I: Integer;
  for I := 0 to Length(Enemies) - 1 do
  begin
    if i mod 2=0 then
    Enemies[I].Left := Enemies[I].Left - EnemySpeed
    else
    Enemies[I].Left := Enemies[I].Left + EnemySpeed;
  end;
end;

//====================================== level 2 ===============================================

procedure CreateSquare(AForm: TForm; posleft, postop: Integer; direction:integer=0 );
begin
  Square := TShape.Create(AForm);
  Square.Parent := AForm;
  Square.Shape := stRectangle;
  Square.Brush.Color := clRed;
  Square.Width := 50;
  Square.Height := 50;
  Square.Left := posleft;
  Square.Top := postop;
  SetLength(Enemies, Length(Enemies) + 1);
  Enemies[Length(Enemies) - 1] := Square;
  case direction of
    5: Square.Tag := 5; // Движение влево
    6: Square.Tag := 6;  // Движение вправо
    7: Square.Tag := 7; // Движение вверх
    8: Square.Tag := 8;  // Движение вниз
    end;
end;

procedure TForm1.LVL2_createTimer(Sender: TObject);
begin
  MainText.Caption:='';
  b:=b+400;
  CreateSquare(self,b,0,8);
  LVL2_createS.Enabled:=true;
  if b>=2400 then
    begin
      LVL2_3sec.Enabled:=true;
      LVL2_create.Enabled	:=false;
      b:=0;
    end;
end;

procedure TForm1.LVL2_3secTimer(Sender: TObject);
begin
   LVL2_create2.Enabled:=true;
end;

procedure TForm1.LVL2_create2Timer(Sender: TObject);
begin
  MainText.Caption:='';
  b:=b+400;
  CreateSquare(self,b,form1.Height,7);
  LVL2_createS.Enabled:=true;
  if b>=2000 then
    begin
      Image4.Picture.LoadFromFile('3.jpg');
      if progres_point < 2 then
      begin
        progres_point:=2;
        AssignFile(F, 'progres_point.txt');
        Rewrite(F);
        write(F,progres_point);
        Closefile(F);
      end;
      Media('win.mp3');
      normalaz;
      winT.Enabled :=true;
      win.Visible :=true;
    end;
end;

procedure TForm1.LVL2_createSTimer(Sender: TObject);
begin
  CreateEnemy(Self, Square.Top - 20, Square.Left + 4, 3); // Создаем врага над квадратом, движущегося вверх
  CreateEnemy(Self, Square.Top + 20, Square.Left + 4, 4); // Создаем врага под квадратом, движущегося вниз
  CreateEnemy(Self, Square.Top , Square.Left - 10, 1); // Создаем врага слева от квадрата, движущегося влево
  CreateEnemy(Self, Square.Top , Square.Left + 20, 2); // Создаем врага справа от квадрата, движущегося вправо
end;

procedure TForm1.LVL2_moveTimer(Sender: TObject);
  var
  i: Integer;
begin
  for i := 0 to Length(Enemies) - 1 do
    begin    
      case Enemies[i].Tag of
      1: Enemies[i].Left := Enemies[i].Left - EnemySpeed; // Движение влево
      2: Enemies[i].Left := Enemies[i].Left + EnemySpeed;  // Движение вправо
      3: Enemies[i].Top := Enemies[i].Top - EnemySpeed;   // Движение вверх
      4: Enemies[i].Top := Enemies[i].Top + EnemySpeed;    // Движение вниз
      7: Enemies[i].Top := Enemies[i].Top - Round(EnemySpeed/2.2);    // Движение вверх для квадрата
      8: Enemies[i].Top := Enemies[i].Top + Round(EnemySpeed/2.2);    // Движение вниз для кв
      end;
    end;
end;

//========================================= level 3 ===============================================

procedure CreateRectangle(AForm: TForm);
var
  Enemy: TShape;
begin
  Enemy := TShape.Create(AForm);
  Enemy.Parent := AForm;
  Enemy.Shape := stRectangle;
  Enemy.Brush.Color := clRed;
  Enemy.Width := 20;
  Enemy.Height := 20;
  Enemy.Left := Random(AForm.ClientWidth - Enemy.Width);  // Случайная начальная позиция по горизонтали
  Enemy.Top := Random(AForm.ClientHeight - Enemy.Height);  // Случайная начальная позиция по вертикали

  SetLength(Enemies2, Length(Enemies2) + 1);
  Enemies2[Length(Enemies2) - 1] := Enemy;
end;

procedure MoveEnemiesToPlayer(AForm: TForm; PlayerX, PlayerY: Integer);
var
  i: Integer;
  EnemyX, EnemyY: Integer;
  DirectionX, DirectionY: Integer;
  Speed: Integer;
begin
  Speed := 4;

  for i := 0 to Length(Enemies2) - 1 do
  begin
    EnemyX := Enemies2[i].Left + Enemies2[i].Width div 2;
    EnemyY := Enemies2[i].Top + Enemies2[i].Height div 2;

    DirectionX := PlayerX - EnemyX;
    DirectionY := PlayerY - EnemyY;

    // Вычисляем длину вектора направления
    var DirectionLength := Sqrt(Sqr(DirectionX) + Sqr(DirectionY));
    if DirectionLength > 0 then
    begin
      DirectionX := Round(DirectionX / DirectionLength * Speed);
      DirectionY := Round(DirectionY / DirectionLength * Speed);
    end;

      Enemies2[i].Left := Enemies2[i].Left + DirectionX;
      Enemies2[i].Top := Enemies2[i].Top + DirectionY;
  end;
end;

procedure TForm1.LVL3_3secTimer(Sender: TObject);
begin
    MainText.Caption:='';
    LVL3_create.Enabled:=true;
    LVL3_move.Enabled:=true;
    LVL3_3sec.Enabled:=false;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
application.Terminate;
end;

procedure TForm1.LVL3_createTimer(Sender: TObject);
begin
  if Length(Enemies2) > 25 then
    begin
      Image5.Picture.LoadFromFile('4.jpg');
      if progres_point < 3 then
      begin
        progres_point:=3;
        AssignFile(F, 'progres_point.txt');
        Rewrite(F);
        write(F,progres_point);
        Closefile(F);
      end;
      Media('win.mp3');
      normalaz;
      winT.Enabled :=true;
      win.Visible :=true;
    end;
  CreateRectangle(self);
end;

procedure TForm1.LVL3_moveTimer(Sender: TObject);
var I: integer;
begin
    MoveEnemiesToPlayer(Self, Player.Left + Player.Width div 2, Player.Top + Player.Height div 2);
end;

//============================================ level 4 ==================================================

procedure TForm1.LVL4_3secTimer(Sender: TObject);
begin
  MainText.Caption:='';
  LVL4_create.Enabled	:=true;
  LVL2_move.Enabled :=true;
  LVL4_3sec.Enabled	:=false;
  c:=Form1.ClientWidth;
  d:=1;
  b:=1;
end;

procedure TForm1.LVL4_3sec2Timer(Sender: TObject);
begin
      Image6.Picture.LoadFromFile('5.jpg');
      if progres_point < 4 then
      begin
        progres_point:=4;
        AssignFile(F, 'progres_point.txt');
        Rewrite(F);
        write(F,progres_point);
        Closefile(F);
      end;
      Media('win.mp3');
      normalaz;
      winT.Enabled :=true;
      win.Visible :=true;
end;

procedure TForm1.LVL4_createTimer(Sender: TObject);
begin
    if b mod 10=0 then 
    begin
     c:=0;
     d:=2;
     LVL4_create2.Enabled:=true;
    end;
    b:=b+1;
    CreateEnemy(Self,random(Screen.Height),c,d);
end;

procedure TForm1.LVL4_create2Timer(Sender: TObject);
begin
    CreateEnemy(Self,Screen.width,random(Screen.width),3);
    CreateEnemy(Self,0,random(Screen.width),4);
    if b mod 10=0 then LVL4_create3.Enabled :=true;
end;

procedure TForm1.LVL4_create3Timer(Sender: TObject);
begin
  CreateSquare(self,random(Screen.width),0,8);
  LVL2_createS.Enabled:=true;
end;

//============================================ level 5 ==================================================

procedure TForm1.LVL5_3secTimer(Sender: TObject);
begin
  MainText.Caption:='';
  LVL5_3sec.Enabled :=false;
  LVL5_create.Enabled	:=true;
  LVL3_move.Enabled	:=true;
  LVL2_move.Enabled:=true;
end;

procedure TForm1.LVL5_createTimer(Sender: TObject);
begin
  CreateEnemy(Self,Screen.Height,random(Screen.width),3);
  CreateEnemy(Self,0,random(Screen.width),4);
  CreateEnemy(Self,random(Screen.Height),Screen.width, 1); 
  CreateEnemy(Self,random(Screen.Height),0, 2);
  LVL5_create2.Enabled :=true;
  LVL4_3sec2.Interval:=60000;
  LVL4_3sec2.Enabled :=true;
end;

procedure TForm1.LVL5_create2Timer(Sender: TObject);
begin
   CreateRectangle(self);
end;

end.
