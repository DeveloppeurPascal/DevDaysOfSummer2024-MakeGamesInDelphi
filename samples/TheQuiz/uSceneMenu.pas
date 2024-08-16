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
/// File last update : 2024-08-10T13:23:32.000+02:00
/// Signature : 211ce5732a94ae98ba9781843d3ebf94034b02b1
/// ***************************************************************************
/// </summary>

unit uSceneMenu;

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
  FMX.Controls.Presentation,
  FMX.Layouts,
  cButtonQuit,
  cButtonCredits,
  cButton,
  cButtonPlay;

type
  TSceneHome = class(T__SceneAncestor)
    Layout1: TLayout;
    cadButtonPlay1: TcadButtonPlay;
    cadButtonCredits1: TcadButtonCredits;
    cadButtonQuit1: TcadButtonQuit;
  private
  protected
    procedure btnNewGameClick(Sender: TObject);
    procedure btnCreditsClick(Sender: TObject);
    procedure btnQuitClick(Sender: TObject);
  public
    procedure ShowScene; override;
    procedure BeforeFirstShowScene; override;
  end;

implementation

{$R *.fmx}

uses
  System.Messaging,
  uScene,
  uGameData,
  uConsts,
  uSoundEffects,
  uUIElements,
  USVGInputPrompts,
  uDMHelpBarManager;

{ TSceneHome }

procedure TSceneHome.BeforeFirstShowScene;
begin
  inherited;
  THelpBarManager.Current.TextSettings.FontColor := talphacolors.Ghostwhite;
  THelpBarManager.Current.TextSettings.Font.Size :=
    THelpBarManager.Current.TextSettings.Font.Size * 2;
  THelpBarManager.Current.BackgroundFill.Color := talphacolors.Black;
  THelpBarManager.Current.Height := 100;
end;

procedure TSceneHome.btnCreditsClick(Sender: TObject);
begin
  TScene.Current := TSceneType.Credits;
end;

procedure TSceneHome.btnNewGameClick(Sender: TObject);
begin
  TGameData.DefaultGameData.StartANewGame;
  TScene.Current := TSceneType.game;
end;

procedure TSceneHome.btnQuitClick(Sender: TObject);
begin
  TScene.Current := TSceneType.Exit;
end;

procedure TSceneHome.ShowScene;
begin
  inherited;

{$IF Defined(IOS) or Defined(ANDROID)}
  cadButtonQuit1.Visible := false;
{$ENDIF}
  cadButtonPlay1.OnClick := btnNewGameClick;
  cadButtonCredits1.OnClick := btnCreditsClick;
  cadButtonQuit1.OnClick := btnQuitClick;

  TUIItemsList.Current.AddControl(cadButtonPlay1, nil, cadButtonCredits1,
    cadButtonCredits1, nil, true);
  if cadButtonQuit1.Visible then
  begin
    TUIItemsList.Current.AddControl(cadButtonCredits1, cadButtonPlay1,
      cadButtonQuit1, cadButtonQuit1, cadButtonPlay1);
    TUIItemsList.Current.AddControl(cadButtonQuit1, cadButtonCredits1, nil, nil,
      cadButtonCredits1, false, true);
  end
  else
    TUIItemsList.Current.AddControl(cadButtonCredits1, cadButtonPlay1, nil, nil,
      cadButtonPlay1);

  THelpBarManager.Current.OpenHelpBar;
  THelpBarManager.Current.AddItem(ord(TSVGInputPromptsIndex.KeyboardArrowUp),
    ord(TSVGInputPromptsIndex.SteamDpadUpOutline));
  THelpBarManager.Current.AddItem(ord(TSVGInputPromptsIndex.KeyboardArrowDown),
    ord(TSVGInputPromptsIndex.SteamDpadDownOutline), 'Move');
  THelpBarManager.Current.AddItem(ord(TSVGInputPromptsIndex.KeyboardSpace),
    ord(TSVGInputPromptsIndex.SteamButtonColorAOutline), 'Select');
  if cadButtonQuit1.Visible then
    THelpBarManager.Current.AddItem(ord(TSVGInputPromptsIndex.KeyboardEscape),
      ord(TSVGInputPromptsIndex.SteamButtonColorXOutline), 'Quit');
end;

initialization

TMessageManager.DefaultManager.SubscribeToMessage(TSceneFactory,
  procedure(const Sender: TObject; const Msg: TMessage)
  var
    NewScene: TSceneHome;
  begin
    if (Msg is TSceneFactory) and
      ((Msg as TSceneFactory).SceneType = TSceneType.Menu) then
    begin
      NewScene := TSceneHome.Create(application.mainform);
      NewScene.Parent := application.mainform;
      TScene.RegisterScene(TSceneType.Menu, NewScene);
    end;
  end);

end.
