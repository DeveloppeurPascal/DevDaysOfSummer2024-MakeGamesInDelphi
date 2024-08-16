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
/// File last update : 2024-08-11T19:09:50.000+02:00
/// Signature : 3eb3aa7642b2d591fbbbfe1bc594890aabed7e67
/// ***************************************************************************
/// </summary>

unit uSceneSplashScreen;

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
  FMX.Objects,
  FMX.Layouts;

type
  TSceneSplashScreen = class(T__SceneAncestor)
    Layout1: TLayout;
    Rectangle1: TRectangle;
  private
  public
    procedure ShowScene; override;
  end;

implementation

{$R *.fmx}

uses
  System.Messaging,
  uScene,
  uConsts;

{ TSceneSplashScreen }

procedure TSceneSplashScreen.ShowScene;
var
  lw: integer;
begin
  inherited;
  lw := round(Layout1.Width);
  Rectangle1.Width := 0;
  Rectangle1.height := Layout1.height;
  tthread.CreateAnonymousThread(
    procedure
    var
      i: integer;
      step: integer;
    begin
      // We wait 3 seconds (30 * 100ms) before showing the main menu.
      // The rectangle is used as an "initialization" progress bar.
      step := round(lw / 30);
      for i := 1 to 30 do
      begin
        sleep(100);
        tthread.queue(nil,
          procedure
          begin
            Rectangle1.Width := Rectangle1.Width + step;
          end);
      end;
      tthread.queue(nil,
        procedure
        begin
          TScene.Current := TSceneType.Menu;
        end);
    end).Start;
end;

initialization

TMessageManager.DefaultManager.SubscribeToMessage(TSceneFactory,
  procedure(const Sender: TObject; const Msg: TMessage)
  var
    NewScene: TSceneSplashScreen;
  begin
    if (Msg is TSceneFactory) and
      ((Msg as TSceneFactory).SceneType = TSceneType.SplashScreen) then
    begin
      NewScene := TSceneSplashScreen.Create(application.mainform);
      NewScene.Parent := application.mainform;
      TScene.RegisterScene(TSceneType.SplashScreen, NewScene);
    end;
  end);

end.
