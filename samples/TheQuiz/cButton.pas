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
/// File last update : 2024-08-11T11:34:12.000+02:00
/// Signature : b21c7e2f1c3876d16f8eb0488250d7396e67a423
/// ***************************************************************************
/// </summary>

unit cButton;

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
  FMX.Objects,
  FMX.Layouts,
  FMX.Effects,
  System.Messaging,
  uUIElements;

type
  TcadButton = class(TFrame, IUIControl)
    lUp: TLayout;
    lDown: TLayout;
    rFocused: TRectangle;
    txtDown: TText;
    txtUp: TText;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    ShadowEffect1: TShadowEffect;
    ShadowEffect2: TShadowEffect;
    procedure FrameMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure FrameMouseLeave(Sender: TObject);
  private
    FIsFocused: boolean;
    FIsDown: boolean;
    FText: string;
    procedure SetIsDown(const Value: boolean);
    procedure SetIsFocused(const Value: boolean);
    procedure SetText(const Value: string);
  protected
    procedure Refresh;
    procedure DoTranslateTexts(const Sender: TObject; const Msg: TMessage);
    procedure Click; override;
  public
    property IsFocused: boolean read FIsFocused write SetIsFocused;
    property IsDown: boolean read FIsDown write SetIsDown;
    property Text: string read FText write SetText;
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    constructor Create(AOwner: TComponent); override;
    procedure TranslateTexts(const Language: string); virtual;
    procedure SetFocus;
    procedure ResetFocus;
  end;

implementation

{$R *.fmx}

uses
  uConfig,
  uTranslate,
  Gamolf.RTL.UIElements;

{ TcadButton }

procedure TcadButton.AfterConstruction;
begin
  inherited;
  tthread.ForceQueue(nil,
    procedure
    begin
      TranslateTexts(tconfig.Current.Language);
      TMessageManager.DefaultManager.SubscribeToMessage(TTranslateTextsMessage,
        DoTranslateTexts);
      Refresh;
    end);
end;

procedure TcadButton.BeforeDestruction;
begin
  inherited;
  TMessageManager.DefaultManager.Unsubscribe(TTranslateTextsMessage,
    DoTranslateTexts, true);
end;

procedure TcadButton.Click;
begin
  IsDown := true;

  if (not IsFocused) and (tagobject is TUIElement) then
    (tagobject as TUIElement).IsFocused := true;

  tthread.CreateAnonymousThread(
    procedure
    begin
      sleep(50);
      tthread.queue(nil,
        procedure
        begin
          if not assigned(self) then
            exit;
          IsDown := false;

          inherited;
        end);
    end).Start;
end;

constructor TcadButton.Create(AOwner: TComponent);
begin
  inherited;
  FIsFocused := false;
  FIsDown := false;
end;

procedure TcadButton.DoTranslateTexts(const Sender: TObject;
const Msg: TMessage);
begin
  if not assigned(self) then
    exit;

  if assigned(Msg) and (Msg is TTranslateTextsMessage) then
    TranslateTexts((Msg as TTranslateTextsMessage).Language);
end;

procedure TcadButton.FrameMouseDown(Sender: TObject; Button: TMouseButton;
Shift: TShiftState; X, Y: Single);
begin
  IsDown := true;
end;

procedure TcadButton.FrameMouseLeave(Sender: TObject);
begin
  IsDown := false;
end;

procedure TcadButton.Refresh;
begin
  lUp.Visible := not FIsDown;
  lDown.Visible := FIsDown;
  rFocused.Visible := FIsFocused;
end;

procedure TcadButton.ResetFocus;
begin
  IsFocused := false;
end;

procedure TcadButton.SetFocus;
begin
  IsFocused := true;
end;

procedure TcadButton.SetIsDown(const Value: boolean);
begin
  FIsDown := Value;
  Refresh;
end;

procedure TcadButton.SetIsFocused(const Value: boolean);
begin
  FIsFocused := Value;
  Refresh;
end;

procedure TcadButton.SetText(const Value: string);
begin
  FText := Value;
  txtUp.Text := Text;
  txtDown.Text := Text;
end;

procedure TcadButton.TranslateTexts(const Language: string);
begin
  // nothing to do at this level,
  // override this method on each scene where you need to translate something
end;

end.
