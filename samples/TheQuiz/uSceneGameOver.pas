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
/// File last update : 2024-08-10T13:23:46.000+02:00
/// Signature : 5f2c17f867ec98eb06cbbad9dba3400f8c7062af
/// ***************************************************************************
/// </summary>

unit uSceneGameOver;

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
  cDialogBoxBackground,
  cShowMessage;

type
  TSceneGameOverWin = class(T__SceneAncestor)
    cadShowMessage1: TcadShowMessage;
  private
  protected
    procedure btnBackClick(Sender: TObject);
  public
    procedure ShowScene; override;
  end;

implementation

{$R *.fmx}

uses
  System.Messaging,
  uScene,
  uConsts,
  uUIElements,
  USVGInputPrompts,
  uDMHelpBarManager,
  uSoundEffects,
  uGameData;

{ TSceneGameOverWin }

procedure TSceneGameOverWin.btnBackClick(Sender: TObject);
begin
  TSoundEffects.StopAll;
  tscene.Current := TSceneType.Menu;
end;

procedure TSceneGameOverWin.ShowScene;
begin
  inherited;
  cadShowMessage1.cadButtonClose1.OnClick := btnBackClick;

  TUIItemsList.Current.AddControl(cadShowMessage1.cadButtonClose1, nil, nil,
    nil, nil, true, true);

  THelpBarManager.Current.OpenHelpBar;
  THelpBarManager.Current.AddItem(ord(TSVGInputPromptsIndex.KeyboardEscape),
    ord(TSVGInputPromptsIndex.SteamButtonColorXOutline), 'Close');

  cadShowMessage1.Text1.TextSettings.HorzAlign := TTextAlign.Center;
  cadShowMessage1.Text1.Text := 'GAME OVER' + slinebreak + slinebreak +
    'Thanks for playing.' + slinebreak + slinebreak + 'Your final score is ' +
    TGameData.DefaultGameData.Score.ToString;

  TSoundEffects.Play(TSoundEffectType.GameOver);
end;

initialization

TMessageManager.DefaultManager.SubscribeToMessage(TSceneFactory,
  procedure(const Sender: TObject; const Msg: TMessage)
  var
    NewScene: TSceneGameOverWin;
  begin
    if (Msg is TSceneFactory) and
      ((Msg as TSceneFactory).SceneType = TSceneType.GameOver) then
    begin
      NewScene := TSceneGameOverWin.Create(application.mainform);
      NewScene.Parent := application.mainform;
      tscene.RegisterScene(TSceneType.GameOver, NewScene);
    end;
  end);

end.
