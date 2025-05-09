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
/// https://fmxgamestarterkit.developpeur-pascal.fr/
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
/// File last update : 2025-05-09T13:40:20.000+02:00
/// Signature : eef38d37a021b55f1a7107e2465f98d38850e093
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
  TScene.Current := TSceneType.Menu;
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

TScene.RegisterScene<TSceneGameOverWin>(TSceneType.GameOver);

end.
