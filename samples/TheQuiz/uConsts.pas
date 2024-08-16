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
/// File last update : 2024-08-11T11:54:12.000+02:00
/// Signature : ce966788f2e89b62af914a5b489e077ed87b6c3f
/// ***************************************************************************
/// </summary>

unit uConsts;

interface

uses
  System.Types;

const
  CAboutVersionNumber = '1.2';
  CAboutVersionDate = '20240816';
  CAboutGameTitle = 'The Quiz !!!';
  CAboutCopyright = '2024 Patrick Prémartin'; // 2024 your name or anything else
  CAboutGameURL =
    'https://github.com/DeveloppeurPascal/DevDaysOfSummer2024-MakeGamesInDelphi';
  CDefaultLanguage = 'en';
  COpenGameInFullScreenMode = true;
  CDefaultBackgroundMusicPath = '..\..\..\..\_PRIVATE\musics\';
  CBackgroundMusicFileName = '';
  CDefaultSoundEffectsPath = '..\..\..\..\assets\sounds\';
  CEditorFolderName = 'Gamolf';
  CGameFolderName = 'DDoS2024TheQuiz';
  CGameGUID = '{58191C3E-7B73-4CE7-ADDA-84F7124D9F28}';
  CDefaultNbLives = 5;
  CDefaultScore = 0;
  CDefaultLevel = 1;
  CTimeInMSBetweenButtonDownAndUp = 50;

type
{$SCOPEDENUMS ON}
  TSceneType = (None, SplashScreen, Exit, Menu, Game, GameOver, Credits);

Const
  CDefaultSceneOnStartup = TSceneType.SplashScreen;

{$IF Defined(RELEASE)}

var
  GConfigXORKey: TByteDynArray;
  GGameDataXORKey: TByteDynArray;
{$ENDIF}

implementation

uses
  System.SysUtils;

initialization

if CAboutGameTitle.Trim.IsEmpty then
  raise Exception.Create
    ('Please give a title to your game in CAboutGameTitle !');

if CEditorFolderName.Trim.IsEmpty then
  raise Exception.Create
    ('Please give an editor folder name in CEditorFolderName !');

if CGameFolderName.Trim.IsEmpty then
  raise Exception.Create('Please give a game folder name in CGameFolderName !');

if CDefaultLanguage.Trim.IsEmpty then
  raise Exception.Create
    ('Please specify a default language ISO code in CDefaultLanguage !');

if (CDefaultLanguage <> CDefaultLanguage.Trim.ToLower) then
  raise Exception.Create('Please use "' + CDefaultLanguage.Trim.ToLower +
    '" as CDefaultLanguage value.');

{$IFDEF RELEASE}
if (CGameGUID = '{48AD6D06-1BED-4F33-ADCA-267E12D74417}') then
  raise Exception.Create('Wrong GUID. Change it in game settings !');
{$ENDIF}
{$IFDEF DEBUG}
// ReportMemoryLeaksOnShutdown := true;
{$ENDIF}
{$IF Defined(RELEASE)}
{$I '..\..\_PRIVATE\src\ConfigFileXORKey.inc'}
{$I '..\..\_PRIVATE\src\GameDataFileXORKey.inc'}
{$ENDIF}

end.
