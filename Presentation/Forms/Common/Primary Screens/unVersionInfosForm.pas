unit unVersionInfosForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VersionInfoDTOs, ExtCtrls, StdCtrls;

const
  SideMargins = 5;
  TopMargins = 5;

type

  TVersionInfoPanel = class
    private
      FPanel: TPanel;
      FVersionNumberLabel: TLabel;
      FDescriptionLabel: TLabel;
      FFileButton: TButton;

      FVersionInfoDTO: TVersionInfoDTO;
      function GetBootom: Integer;

      procedure OnFileButtonClick(ASender: TObject);
    public

      constructor Create(
        AOwner: TComponent;
        AVersionInfoDTO: TVersionInfoDTO;
        Position: Integer
      );
      destructor Destroy; override;

      property Bottom: Integer read GetBootom;

  end;


  TVersionInfosForm = class(TForm)
    ScrollBox: TScrollBox;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }

    FVersionInfoDTOs: TVersionInfoDTOs;
    FPanelList: TList;
    procedure SetVersionInfoDTOs(const Value: TVersionInfoDTOs);
    procedure FillFormFromDTOs;

  public
    { Public declarations }
    

    constructor Create(
      AOwner: TComponent;
      AVersionInfoDTOs: TVersionInfoDTOs
    );

    property VersionInfoDTOs: TVersionInfoDTOs read FVersionInfoDTOs
      write SetVersionInfoDTOs;
  end;

var
  VersionInfosForm: TVersionInfosForm;

implementation

uses
  AuxSystemFunctionsUnit;

{$R *.dfm}

{ TVersionInfoPanel }

constructor TVersionInfoPanel.Create(
  AOwner: TComponent;
  AVersionInfoDTO: TVersionInfoDTO;
  Position: Integer);
var
  LastVisibleControl: TControl;
begin
  inherited Create;

  FVersionInfoDTO := AVersionInfoDTO;

  FPanel := TPanel.Create(AOwner);
  FPanel.Parent := AOwner as TWinControl;

  FPanel.Top := Position;
  FPanel.AlignWithMargins := True;
  FPanel.Align := alTop;
  FPanel.Margins.Left := SideMargins;
  FPanel.Margins.Right := SideMargins;
  FPanel.Width := (AOwner as TWinControl).Width - FPanel.Margins.Left - FPanel.Margins.Right;

//  FPanel.BevelOuter := bvNone;

  FVersionNumberLabel := TLabel.Create(FPanel);
  FVersionNumberLabel.Parent := FPanel;

  FVersionNumberLabel.AlignWithMargins := True;
  FVersionNumberLabel.Align := alTop;

  FVersionNumberLabel.Caption := 'Версия ' + FVersionInfoDTO.VersionNumber + ' от ' + DateToStr(FVersionInfoDTO.Date);
  FVersionNumberLabel.Width := FPanel.Width - FVersionNumberLabel.Margins.Left - FVersionNumberLabel.Margins.Right;

  FVersionNumberLabel.AutoSize := False;
  FVersionNumberLabel.AutoSize := True;


  FDescriptionLabel := TLabel.Create(FPanel);
  FDescriptionLabel.Parent := FPanel;

  FDescriptionLabel.Top := FVersionNumberLabel.Top + FVersionNumberLabel.Height +
    FVersionNumberLabel.Margins.Bottom + FDescriptionLabel.Margins.Top;

  FDescriptionLabel.AlignWithMargins := True;
  FDescriptionLabel.Align := alTop;
  FDescriptionLabel.Caption := FVersionInfoDTO.Description;
  FDescriptionLabel.WordWrap := True;
  FDescriptionLabel.Width := FPanel.Width - FVersionNumberLabel.Margins.Left - FVersionNumberLabel.Margins.Right;
  FDescriptionLabel.AutoSize := False;
  FDescriptionLabel.AutoSize := True;


  LastVisibleControl := FDescriptionLabel;

  if not VarIsNull(FVersionInfoDTO.FilePath) and (FVersionInfoDTO.FilePath <> '')then
  begin
    FFileButton := TButton.Create(FPanel);
    FFileButton.Parent := FPanel;

    FFileButton.Caption := 'Файл';
    FFileButton.Top := FDescriptionLabel.Top + FDescriptionLabel.Height +
      FDescriptionLabel.Margins.Bottom + FFileButton.Margins.Top;

    FFileButton.Left := 10;
    FFileButton.Width := 50;

    FFileButton.OnClick := OnFileButtonClick;

    LastVisibleControl := FFileButton;

  end;

  FPanel.Height := LastVisibleControl.Top + LastVisibleControl.Height +
    LastVisibleControl.Margins.Bottom + 10;

end;

destructor TVersionInfoPanel.Destroy;
begin
  FreeAndNil(FPanel);
  FreeAndNil(FVersionNumberLabel);
  FreeAndNil(FDescriptionLabel);
  FreeAndNil(FFileButton);
  inherited;
end;

function TVersionInfoPanel.GetBootom: Integer;
begin
  Result :=
    FPanel.Top + FPanel.Height;
end;

procedure TVersionInfoPanel.OnFileButtonClick(ASender: TObject);
begin

  OpenDocument(FVersionInfoDTO.FilePath);
end;

{ TVersionInfosForm }

constructor TVersionInfosForm.Create(AOwner: TComponent;
  AVersionInfoDTOs: TVersionInfoDTOs);
begin

  inherited Create(AOwner);

  if AOwner is TForm then
    Font := (AOwner as TForm).Font
  else if AOwner is TFrame then
    Font := (AOwner as TFrame).Font;

  FPanelList := TList.Create;
  VersionInfoDTOs := AVersionInfoDTOs;

end;

procedure TVersionInfosForm.FillFormFromDTOs;
var
  I: Integer;

  Pos: Integer;
  Panel: TVersionInfoPanel;
begin

  Pos := 0;

  for I := 0 to FVersionInfoDTOs.Count - 1 do
  begin
    Panel :=
      TVersionInfoPanel.Create(
        ScrollBox,
        FVersionInfoDTOs[I],
        Pos
      );

    FPanelList.Add(Panel);
    Pos := Panel.Bottom + 5;

  end;

end;

procedure TVersionInfosForm.FormActivate(Sender: TObject);
begin
  ScrollBox.SetFocus;
  ScrollBox.VertScrollBar.Position := 0;
end;

procedure TVersionInfosForm.SetVersionInfoDTOs(const Value: TVersionInfoDTOs);
begin

  FreeAndNil(FVersionInfoDTOs);
  FPanelList.Clear;

  FVersionInfoDTOs := Value;
  FillFormFromDTOs;
end;

end.
