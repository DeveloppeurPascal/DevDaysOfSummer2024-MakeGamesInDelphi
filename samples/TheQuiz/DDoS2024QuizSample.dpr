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
/// File last update : 2024-08-10T13:24:42.000+02:00
/// Signature : f556bb9277bb0c901e8787b7ca1e666c91fc28b9
/// ***************************************************************************
/// </summary>

program DDoS2024QuizSample;

uses
  System.StartUpCopy,
  FMX.Forms,
  FMX.Skia,
  Olf.FMX.AboutDialog in '..\..\lib-externes\AboutDialog-Delphi-Component\src\Olf.FMX.AboutDialog.pas',
  Olf.FMX.AboutDialogForm in '..\..\lib-externes\AboutDialog-Delphi-Component\src\Olf.FMX.AboutDialogForm.pas' {OlfAboutDialogForm},
  u_urlOpen in '..\..\lib-externes\librairies\src\u_urlOpen.pas',
  uConsts in 'uConsts.pas',
  Olf.RTL.Language in '..\..\lib-externes\librairies\src\Olf.RTL.Language.pas',
  Olf.RTL.CryptDecrypt in '..\..\lib-externes\librairies\src\Olf.RTL.CryptDecrypt.pas',
  Olf.RTL.Params in '..\..\lib-externes\librairies\src\Olf.RTL.Params.pas',
  Olf.Skia.SVGToBitmap in '..\..\lib-externes\librairies\src\Olf.Skia.SVGToBitmap.pas',
  uDMAboutBox in '..\..\lib-externes\Gamolf-FMX-Game-Starter-Kit\starter-kit-src\uDMAboutBox.pas' {AboutBox: TDataModule},
  uDMAboutBoxLogoStorrage in '..\..\lib-externes\Gamolf-FMX-Game-Starter-Kit\starter-kit-src\uDMAboutBoxLogoStorrage.pas' {dmAboutBoxLogo: TDataModule},
  uTxtAboutLicense in 'uTxtAboutLicense.pas',
  uTxtAboutDescription in 'uTxtAboutDescription.pas',
  Gamolf.FMX.HelpBar in '..\..\lib-externes\Delphi-Game-Engine\src\Gamolf.FMX.HelpBar.pas',
  Gamolf.FMX.Joystick in '..\..\lib-externes\Delphi-Game-Engine\src\Gamolf.FMX.Joystick.pas',
  Gamolf.FMX.MusicLoop in '..\..\lib-externes\Delphi-Game-Engine\src\Gamolf.FMX.MusicLoop.pas',
  Gamolf.RTL.GamepadDetected in '..\..\lib-externes\Delphi-Game-Engine\src\Gamolf.RTL.GamepadDetected.pas',
  Gamolf.RTL.Joystick.DirectInput.Win in '..\..\lib-externes\Delphi-Game-Engine\src\Gamolf.RTL.Joystick.DirectInput.Win.pas',
  Gamolf.RTL.Joystick.Helpers in '..\..\lib-externes\Delphi-Game-Engine\src\Gamolf.RTL.Joystick.Helpers.pas',
  Gamolf.RTL.Joystick.Mac in '..\..\lib-externes\Delphi-Game-Engine\src\Gamolf.RTL.Joystick.Mac.pas',
  Gamolf.RTL.Joystick in '..\..\lib-externes\Delphi-Game-Engine\src\Gamolf.RTL.Joystick.pas',
  Gamolf.RTL.Scores in '..\..\lib-externes\Delphi-Game-Engine\src\Gamolf.RTL.Scores.pas',
  Gamolf.RTL.UIElements in '..\..\lib-externes\Delphi-Game-Engine\src\Gamolf.RTL.UIElements.pas',
  iOSapi.GameController in '..\..\lib-externes\Delphi-Game-Engine\src\iOSapi.GameController.pas',
  Macapi.GameController in '..\..\lib-externes\Delphi-Game-Engine\src\Macapi.GameController.pas',
  uTranslate in '..\..\lib-externes\Gamolf-FMX-Game-Starter-Kit\starter-kit-src\uTranslate.pas',
  uConfig in '..\..\lib-externes\Gamolf-FMX-Game-Starter-Kit\starter-kit-src\uConfig.pas',
  uSceneBackground in 'uSceneBackground.pas' {SceneBackground: TFrame},
  uScene in '..\..\lib-externes\Gamolf-FMX-Game-Starter-Kit\starter-kit-src\uScene.pas',
  uSceneMenu in 'uSceneMenu.pas' {SceneHome: TFrame},
  uSceneGame in 'uSceneGame.pas' {SceneGame: TFrame},
  uSceneGameOver in 'uSceneGameOver.pas' {SceneGameOverWin: TFrame},
  uSceneCredits in 'uSceneCredits.pas' {SceneCredits: TFrame},
  uUIElements in '..\..\lib-externes\Gamolf-FMX-Game-Starter-Kit\starter-kit-src\uUIElements.pas',
  uGameData in '..\..\lib-externes\Gamolf-FMX-Game-Starter-Kit\starter-kit-src\uGameData.pas',
  Olf.RTL.Streams in '..\..\lib-externes\librairies\src\Olf.RTL.Streams.pas',
  Olf.RTL.Maths.Conversions in '..\..\lib-externes\librairies\src\Olf.RTL.Maths.Conversions.pas',
  uBackgroundMusic in '..\..\lib-externes\Gamolf-FMX-Game-Starter-Kit\starter-kit-src\uBackgroundMusic.pas',
  uSoundEffects in 'uSoundEffects.pas',
  uDMGameControllerCenter in '..\..\lib-externes\Gamolf-FMX-Game-Starter-Kit\starter-kit-src\uDMGameControllerCenter.pas' {DMGameControllerCenter: TDataModule},
  uDMHelpBarManager in '..\..\lib-externes\Gamolf-FMX-Game-Starter-Kit\starter-kit-src\uDMHelpBarManager.pas' {HelpBarManager: TDataModule},
  cDialogBoxBackground in 'cDialogBoxBackground.pas' {cadDialogBoxBackground: TFrame},
  cButton in 'cButton.pas' {cadButton: TFrame},
  uSceneSplashScreen in 'uSceneSplashScreen.pas' {SceneSplashScreen: TFrame},
  cButtonQuit in 'cButtonQuit.pas' {cadButtonQuit: TFrame},
  cButtonPlay in 'cButtonPlay.pas' {cadButtonPlay: TFrame},
  cButtonHome in 'cButtonHome.pas' {cadButtonHome: TFrame},
  cButtonBack in 'cButtonBack.pas' {cadButtonBack: TFrame},
  cButtonCredits in 'cButtonCredits.pas' {cadButtonCredits: TFrame},
  cShowMessage in 'cShowMessage.pas' {cadShowMessage: TFrame},
  cButtonClose in 'cButtonClose.pas' {cadButtonClose: TFrame},
  fMain in '..\..\lib-externes\Gamolf-FMX-Game-Starter-Kit\starter-kit-src\fMain.pas' {frmMain},
  uSVGBitmapManager in 'uSVGBitmapManager.pas',
  USVGInputPrompts in '..\..\assets\kenney_nl\InputPrompts\USVGInputPrompts.pas',
  _ScenesAncestor in '..\..\lib-externes\Gamolf-FMX-Game-Starter-Kit\starter-kit-src\_ScenesAncestor.pas' {__SceneAncestor: TFrame};

{$R *.res}

begin
  GlobalUseSkia := True;
  Application.Initialize;
  Application.CreateForm(TDMGameControllerCenter, DMGameControllerCenter);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
