/// <summary>
/// ***************************************************************************
///
/// Make games in Delphi (2024 edition) - Dev Days of Summer 2024
///
/// Copyright 2024 Patrick Prémartin under AGPL 3.0 license.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
/// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
/// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
/// DEALINGS IN THE SOFTWARE.
///
/// ***************************************************************************
///
/// Samples projects for the "Make games in Delphi (2024 Edition)" talk at
/// <Dev Days of Summer> 2024 online conference.
///
/// The projects are based on the "Gamolf FMX Game Template" you can find at
/// https://gametemplate.developpeur-pascal.fr/
///
/// ***************************************************************************
///
/// Author(s) :
/// Patrick PREMARTIN
///
/// Site :
/// https://serialstreameur.fr/make-games-in-delphi-2024-edition.html
///
/// Project site :
/// https://github.com/DeveloppeurPascal/DevDaysOfSummer2024-MakeGamesInDelphi
///
/// ***************************************************************************
/// File last update : 2024-08-10T13:47:26.000+02:00
/// Signature : e2a965a628f18cf93d5a07ece6ab4a90a604f1d3
/// ***************************************************************************
/// </summary>

unit uSceneGame;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  _ScenesAncestor,
  System.Messaging,
  FMX.Controls.Presentation,
  FMX.Layouts,
  FMX.Effects,
  FMX.Objects,
  cButton;

type
  TSceneGame = class(T__SceneAncestor)
    Layout1: TLayout;
    Rectangle1: TRectangle;
    GridPanelLayout1: TGridPanelLayout;
    VertScrollBox1: TVertScrollBox;
    txtQuestion: TText;
    btnLeftAnswer: TcadButton;
    btnRightAnswer: TcadButton;
    lblScoreAndLives: TText;
    ShadowEffect1: TShadowEffect;
  private
  protected
    procedure DoScoreChanged(const Sender: TObject; const Msg: TMessage);
    procedure DoNbLivesChanged(const Sender: TObject; const Msg: TMessage);
    procedure AskAQuestion;
    procedure GoodAnswer(Sender: TObject);
    procedure WrongAnswer(Sender: TObject);
    procedure RefreshScoreAndLives;
  public
    procedure ShowScene; override;
    procedure HideScene; override;
    procedure BeforeFirstShowScene; override;
  end;

implementation

{$R *.fmx}

uses
  FMX.DialogService,
  uScene,
  uConsts,
  uGameData,
  uBackgroundMusic,
  uConfig,
  uUIElements,
  USVGInputPrompts,
  uDMHelpBarManager,
  uSoundEffects,
  Gamolf.RTL.UIElements,
  Gamolf.RTL.Joystick;

{ TSceneGame }

procedure TSceneGame.AskAQuestion;
var
  a, b, c, d: integer;
begin
  case random(100) of
    00 .. 09:
      begin
        txtQuestion.Text := 'Choose left button';
        btnLeftAnswer.Text := 'Left';
        btnLeftAnswer.OnClick := GoodAnswer;
        btnRightAnswer.Text := 'Right';
        btnRightAnswer.OnClick := WrongAnswer;
      end;
    10 .. 19:
      begin
        txtQuestion.Text := 'Choose right button';
        btnLeftAnswer.Text := 'Left';
        btnLeftAnswer.OnClick := WrongAnswer;
        btnRightAnswer.Text := 'Right';
        btnRightAnswer.OnClick := GoodAnswer;
      end;
    20 .. 29:
      begin
        txtQuestion.Text := 'Choose "left" button';
        btnLeftAnswer.Text := 'Right';
        btnLeftAnswer.OnClick := WrongAnswer;
        btnRightAnswer.Text := 'Left';
        btnRightAnswer.OnClick := GoodAnswer;
      end;
    30 .. 39:
      begin
        txtQuestion.Text := 'Choose "right" button';
        btnLeftAnswer.Text := 'Right';
        btnLeftAnswer.OnClick := GoodAnswer;
        btnRightAnswer.Text := 'Left';
        btnRightAnswer.OnClick := WrongAnswer;
      end;
    40 .. 49:
      begin
        a := random(50);
        b := random(50);
        c := a + b;
        repeat
          d := c + random(20) - 10;
        until (d <> c);
        txtQuestion.Text := a.tostring + ' + ' + b.tostring + ' =';
        case random(2) of
          0:
            begin
              btnLeftAnswer.Text := d.tostring;
              btnLeftAnswer.OnClick := WrongAnswer;
              btnRightAnswer.Text := c.tostring;
              btnRightAnswer.OnClick := GoodAnswer;
            end;
        else
          btnLeftAnswer.Text := c.tostring;
          btnLeftAnswer.OnClick := GoodAnswer;
          btnRightAnswer.Text := d.tostring;
          btnRightAnswer.OnClick := WrongAnswer;
        end;
      end;
    50 .. 59:
      begin
        a := random(50);
        b := random(50);
        c := a * b;
        repeat
          d := c + random(20) - 10;
        until (d <> c);
        txtQuestion.Text := a.tostring + ' * ' + b.tostring + ' =';
        case random(2) of
          0:
            begin
              btnLeftAnswer.Text := d.tostring;
              btnLeftAnswer.OnClick := WrongAnswer;
              btnRightAnswer.Text := c.tostring;
              btnRightAnswer.OnClick := GoodAnswer;
            end;
        else
          btnLeftAnswer.Text := c.tostring;
          btnLeftAnswer.OnClick := GoodAnswer;
          btnRightAnswer.Text := d.tostring;
          btnRightAnswer.OnClick := WrongAnswer;
        end;
      end;
    60 .. 69:
      begin
        a := random(50);
        b := random(50);
        c := a - b;
        repeat
          d := c + random(20) - 10;
        until (d <> c);
        txtQuestion.Text := a.tostring + ' - ' + b.tostring + ' =';
        case random(2) of
          0:
            begin
              btnLeftAnswer.Text := d.tostring;
              btnLeftAnswer.OnClick := WrongAnswer;
              btnRightAnswer.Text := c.tostring;
              btnRightAnswer.OnClick := GoodAnswer;
            end;
        else
          btnLeftAnswer.Text := c.tostring;
          btnLeftAnswer.OnClick := GoodAnswer;
          btnRightAnswer.Text := d.tostring;
          btnRightAnswer.OnClick := WrongAnswer;
        end;
      end;
  else
    txtQuestion.Text := 'LOL ?';
    btnLeftAnswer.Text := 'Sure !';
    btnLeftAnswer.OnClick := GoodAnswer;
    btnRightAnswer.Text := 'A lot of !';
    btnRightAnswer.OnClick := GoodAnswer;
  end;
end;

procedure TSceneGame.BeforeFirstShowScene;
begin
  inherited;
  lblScoreAndLives.TextSettings.Font.Size :=
    lblScoreAndLives.TextSettings.Font.Size * 2;
  txtQuestion.Font.Size := txtQuestion.Font.Size * 2;
end;

procedure TSceneGame.DoNbLivesChanged(const Sender: TObject;
  const Msg: TMessage);
begin
  if not assigned(self) then
    exit;

  if assigned(Msg) and (Msg is TNbLivesChangedMessage) then
    RefreshScoreAndLives;
end;

procedure TSceneGame.DoScoreChanged(const Sender: TObject; const Msg: TMessage);
begin
  if not assigned(self) then
    exit;

  if assigned(Msg) and (Msg is TScoreChangedMessage) then
    RefreshScoreAndLives;
end;

procedure TSceneGame.HideScene;
begin
  inherited;
  TMessageManager.DefaultManager.Unsubscribe(TScoreChangedMessage,
    DoScoreChanged, true);
  TMessageManager.DefaultManager.Unsubscribe(TNbLivesChangedMessage,
    DoNbLivesChanged, true);
end;

procedure TSceneGame.RefreshScoreAndLives;
begin
  lblScoreAndLives.Text := 'Score : ' +
    TGameData.DefaultGameData.Score.tostring;
  lblScoreAndLives.Text := lblScoreAndLives.Text + ' - ';
  lblScoreAndLives.Text := lblScoreAndLives.Text + 'Lives : ' +
    TGameData.DefaultGameData.NbLives.tostring;
end;

procedure TSceneGame.GoodAnswer(Sender: TObject);
begin
  TGameData.DefaultGameData.Score := TGameData.DefaultGameData.Score +
    TGameData.DefaultGameData.NbLives;
  TSoundEffects.Play(TSoundEffectType.GoodAnswer);
  AskAQuestion;
end;

procedure TSceneGame.ShowScene;
var
  item: TUIElement;
begin
  inherited;
  TMessageManager.DefaultManager.SubscribeToMessage(TScoreChangedMessage,
    DoScoreChanged);
  TMessageManager.DefaultManager.SubscribeToMessage(TNbLivesChangedMessage,
    DoNbLivesChanged);
  RefreshScoreAndLives;

  item := TUIItemsList.Current.AddUIItem(
    procedure(const Sender: TObject)
    begin
      TScene.Current := TSceneType.GameOver;
    end);
  item.TagObject := self; // I don't want to be on left/right of other buttons
  item.KeyShortcuts.Add(vkEscape, #0, []);
  item.KeyShortcuts.Add(vkHardwareBack, #0, []);
  item.GamePadButtons := [TJoystickButtons.x];

  TUIItemsList.Current.AddControl(btnLeftAnswer, nil, btnRightAnswer, nil,
    nil, true);
  TUIItemsList.Current.AddControl(btnRightAnswer, nil, nil, nil, btnLeftAnswer);

  THelpBarManager.Current.OpenHelpBar;
  THelpBarManager.Current.AddItem(ord(TSVGInputPromptsIndex.KeyboardArrowLeft),
    ord(TSVGInputPromptsIndex.SteamDpadLeftOutline));
  THelpBarManager.Current.AddItem(ord(TSVGInputPromptsIndex.KeyboardArrowRight),
    ord(TSVGInputPromptsIndex.SteamDpadRightOutline), 'Move');
  THelpBarManager.Current.AddItem(ord(TSVGInputPromptsIndex.KeyboardSpace),
    ord(TSVGInputPromptsIndex.SteamButtonColorAOutline), 'Select');
  THelpBarManager.Current.AddItem(ord(TSVGInputPromptsIndex.KeyboardEscape),
    ord(TSVGInputPromptsIndex.SteamButtonColorXOutline), 'Exit');

  TSoundEffects.Play(TSoundEffectType.StartGame);

  AskAQuestion;
end;

procedure TSceneGame.WrongAnswer(Sender: TObject);
begin
  TGameData.DefaultGameData.NbLives := TGameData.DefaultGameData.NbLives - 1;
  if TGameData.DefaultGameData.NbLives < 1 then
  begin
    TGameData.DefaultGameData.StopGame;
    TScene.Current := TSceneType.GameOver;
  end
  else
  begin
    TSoundEffects.Play(TSoundEffectType.WrongAnswer);
    AskAQuestion;
  end;
end;

initialization

TMessageManager.DefaultManager.SubscribeToMessage(TSceneFactory,
  procedure(const Sender: TObject; const Msg: TMessage)
  var
    NewScene: TSceneGame;
  begin
    if (Msg is TSceneFactory) and
      ((Msg as TSceneFactory).SceneType = TSceneType.Game) then
    begin
      NewScene := TSceneGame.Create(application.mainform);
      NewScene.Parent := application.mainform;
      TScene.RegisterScene(TSceneType.Game, NewScene);
    end;
  end);

end.
