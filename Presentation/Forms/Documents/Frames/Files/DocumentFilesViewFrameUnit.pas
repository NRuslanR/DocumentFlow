unit DocumentFilesViewFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, PDFViewFormUnit, DocumentFileInfoList, unDocumentCardInformationFrame;

type

  TOnDocumentFileShowingEventHandler =
    procedure (
      Sender: TObject;
      ShowableDocumentFileInfo: TDocumentFileInfo;
      var TargetDocumentFilePath: String
    ) of object;
    
  TDocumentFilesViewFrame = class(TDocumentCardInformationFrame)

    DocumentFilesLabel: TLabel;
    DocumentFilesListBox: TListBox;
    DocumentFileListPanel: TPanel;
    SplitterBetweenDocumentFileListPanelAndDocumentFileViewArea: TSplitter;
    DocumentFileViewAreaPanel: TPanel;
    procedure DocumentFilesListBoxClick(Sender: TObject);

  private

    FPDFViewForm: TPDFViewForm;

    FOnDocumentFileShowingEventHandler: TOnDocumentFileShowingEventHandler;
    
    FEnableUIAndDocumentFileInfoSynchronization: Boolean;
    
    FCurrentDocumentFileInfo: TDocumentFileInfo;
    FDocumentFileInfoList: TDocumentFileInfoList;

    FErrorFileList: TStrings;
    
    procedure Initialize; overload; override;

    procedure Initialize(
      PDFViewForm: TPDFViewForm = nil;
      EnableUIAndDocumentFileInfoSynchronization: Boolean = True
    ); overload;

  private

    procedure OnDocumentFileInfoSelectionChanged(
      SelectedDocumentFileInfo: TDocumentFileInfo
    );

    procedure RaiseOnDocumentFileShowingEventHandler(
      ShowableDocumentFileInfo: TDocumentFileInfo;
      var TargetDocumentFilePath: String
    );

    procedure RaiseOnDocumentFileInfoItemSelectionChangedIfNecessary;
    
  private

    procedure InflatePDFViewForm(PDFViewForm: TPDFViewForm);
    procedure FillDocumentFileInfoListBox;
    procedure ShowDocumentFileInViewArea(const FilePath: String);
    procedure ChooseDocumentFileInfoItemAndShowRelatedDocumentFile(
      const ItemIndex: Integer
    );

    function IsPDFDocumentFile(DocumentFileInfo: TDocumentFileInfo): Boolean;
    
    procedure AddDocumentFileInfoItemToListBox(
      DocumentFileInfo: TDocumentFileInfo
    );

    procedure RemoveDocumentFileInfoItemFromListBox(
      const ItemIndex: Integer
    );
    
    function GetDocumentFileInfoByItemIndex(
      const ItemIndex: Integer
    ): TDocumentFileInfo;

    procedure SetStyleToControls;

  private

    procedure SetEnableUIAndDocumentFileInfoSynchronization(
      Value: Boolean
    );
    procedure SetPDFViewForm(const Value: TPDFViewForm);
    function GetCurrentDocumentFileName: String;
    procedure SetCurrentDocumentFileName(const Value: String);

  protected

    procedure ApplyUIStyles; override;

    procedure SetViewOnly(const Value: Boolean); override;

  protected

    function GetDocumentFileListVisible: Boolean;
    procedure SetDocumentFileListVisible(const Value: Boolean);
    
  public

    destructor Destroy; override;

    constructor Create(
      AOwner: TComponent;
      EnableUIAndDocumentFileInfoSynchronization: Boolean = True
    ); overload;

    constructor Create(
      AOwner: TComponent;
      PDFViewForm: TPDFViewForm;
      EnableUIAndDocumentFileInfoSynchronization: Boolean = True
    ); overload;

    procedure SetDocumentFileInfoList(
      DocumentFileInfoList: TDocumentFileInfoList
    );

    procedure Clear;

    procedure AddDocumentFileInfo(DocumentFileInfo: TDocumentFileInfo);

    procedure RemoveDocumentFileInfo(const FileName: String);

    procedure SynchronizeUIWithCurrentDocumentFileInfoIfNecessary;

    property DocumentFileListVisible: Boolean
    read GetDocumentFileListVisible write SetDocumentFileListVisible;

    property CurrentDocumentFileName: String
    read GetCurrentDocumentFileName write SetCurrentDocumentFileName;

    property PDFViewForm: TPDFViewForm
    read FPDFViewForm write SetPDFViewForm;

    property EnableUIAndDocumentFileInfoSynchronization: Boolean
    read FEnableUIAndDocumentFileInfoSynchronization
    write SetEnableUIAndDocumentFileInfoSynchronization;

    property OnDocumentFileShowingEventHandler: TOnDocumentFileShowingEventHandler
    read FOnDocumentFileShowingEventHandler write FOnDocumentFileShowingEventHandler;
    
  end;

var
  DocumentFilesViewFrame: TDocumentFilesViewFrame;

implementation

{$R *.dfm}

uses

  StrUtils,
  cxButtons,
  CommonControlStyles,
  ApplicationServiceRegistries,
  unDocumentFlowCardInformationFrame;

{ TDocumentFilesViewFrame }

procedure TDocumentFilesViewFrame.AddDocumentFileInfo(
  DocumentFileInfo: TDocumentFileInfo);
var FileExtension: String;
begin

  if not IsPDFDocumentFile(DocumentFileInfo) then Exit;

  FDocumentFileInfoList.Add(DocumentFileInfo);

  AddDocumentFileInfoItemToListBox(DocumentFileInfo);

  if EnableUIAndDocumentFileInfoSynchronization then
    RaiseOnDocumentFileInfoItemSelectionChangedIfNecessary;

end;

procedure TDocumentFilesViewFrame.AddDocumentFileInfoItemToListBox(
  DocumentFileInfo: TDocumentFileInfo);
begin

  if not IsPDFDocumentFile(DocumentFileInfo) then Exit;
  
  DocumentFilesListBox.AddItem(
    DocumentFileInfo.FileName,
    DocumentFileInfo
  );

  if DocumentFilesListBox.Count = 1 then
    DocumentFilesListBox.ItemIndex := 0;
  
end;

procedure TDocumentFilesViewFrame.ApplyUIStyles;
begin

  inherited;

  DocumentFilesLabel.Font.Style := [fsBold];
  
end;

procedure TDocumentFilesViewFrame.
  ChooseDocumentFileInfoItemAndShowRelatedDocumentFile(
    const ItemIndex: Integer
  );
var DocumentFileInfo: TDocumentFileInfo;

  function IsDocumentFileInfoItemIndexValid(const ItemIndex: Integer): Boolean;
  begin

    Result := (ItemIndex >= 0) and (ItemIndex < DocumentFilesListBox.Count);
    
  end;

begin

  if not IsDocumentFileInfoItemIndexValid(ItemIndex) then
    Exit;
  
  DocumentFilesListBox.ItemIndex := ItemIndex;

  DocumentFileInfo := FDocumentFileInfoList[ItemIndex];

  ShowDocumentFileInViewArea(DocumentFileInfo.FilePath);

end;

procedure TDocumentFilesViewFrame.Clear;
begin

  DocumentFilesListBox.Clear;

  FDocumentFileInfoList := nil;

  FPDFViewForm.ClearDocument;

end;

constructor TDocumentFilesViewFrame.Create(
  AOwner: TComponent;
  PDFViewForm: TPDFViewForm;
  EnableUIAndDocumentFileInfoSynchronization: Boolean
);
begin

  inherited Create(AOwner);

  Initialize(PDFViewForm, EnableUIAndDocumentFileInfoSynchronization);
  
end;

constructor TDocumentFilesViewFrame.Create(
  AOwner: TComponent;
  EnableUIAndDocumentFileInfoSynchronization: Boolean
);
begin

  inherited Create(AOwner);

  Initialize(nil, EnableUIAndDocumentFileInfoSynchronization);
  
end;

procedure TDocumentFilesViewFrame.InflatePDFViewForm(PDFViewForm: TPDFViewForm);
begin

  PDFViewForm.Parent := DocumentFileViewAreaPanel;
  PDFViewForm.BorderStyle := bsNone;
  PDFViewForm.Align := alClient;
  
  PDFViewForm.Show;

end;

procedure TDocumentFilesViewFrame.Initialize;
begin

  inherited;

  EnableScrolling := False;

end;

destructor TDocumentFilesViewFrame.Destroy;
begin

  FreeAndNil(FDocumentFileInfoList);
  FreeAndNil(FPDFViewForm);
  FreeAndNil(FErrorFileList);
  
  inherited;

end;

procedure TDocumentFilesViewFrame.DocumentFilesListBoxClick(Sender: TObject);
begin

  RaiseOnDocumentFileInfoItemSelectionChangedIfNecessary;

end;

procedure TDocumentFilesViewFrame.FillDocumentFileInfoListBox;
var DocumentFileInfo: TDocumentFileInfo;
begin

  DocumentFilesListBox.Clear;
  
  for DocumentFileInfo in FDocumentFileInfoList do
    AddDocumentFileInfoItemToListBox(DocumentFileInfo);

end;

function TDocumentFilesViewFrame.GetCurrentDocumentFileName: String;
begin

  Result :=
    IfThen(
      Assigned(FCurrentDocumentFileInfo),
      FCurrentDocumentFileInfo.FileName,
      ''
    );

end;

function TDocumentFilesViewFrame.GetDocumentFileInfoByItemIndex(
  const ItemIndex: Integer): TDocumentFileInfo;
begin

  Result :=
    DocumentFilesListBox.Items.Objects[ItemIndex] as TDocumentFileInfo;

end;

function TDocumentFilesViewFrame.GetDocumentFileListVisible: Boolean;
begin

  Result := DocumentFileListPanel.Visible;

end;

procedure TDocumentFilesViewFrame.Initialize(
  PDFViewForm: TPDFViewForm;
  EnableUIAndDocumentFileInfoSynchronization: Boolean
);
begin

  if not Assigned(PDFViewForm) then
    FPDFViewForm := TPDFViewForm.Create(Self)

  else if FPDFViewForm = PDFViewForm then Exit

  else begin

    FreeAndNil(FPDFViewForm);
    
    FPDFViewForm := PDFViewForm;

    InsertComponent(PDFViewForm);
    
  end;

  InflatePDFViewForm(FPDFViewForm);
  
  SetStyleToControls;

  FDocumentFileInfoList := TDocumentFileInfoList.Create;

  FCurrentDocumentFileInfo := nil;

  FErrorFileList := TStringList.Create;

  FEnableUIAndDocumentFileInfoSynchronization :=
    EnableUIAndDocumentFileInfoSynchronization;
    
end;

function TDocumentFilesViewFrame.IsPDFDocumentFile(
  DocumentFileInfo: TDocumentFileInfo): Boolean;
var FileExtension: String;
begin

  FileExtension := LowerCase(ExtractFileExt(DocumentFileInfo.FilePath));

  Result := ContainsStr(FileExtension, 'pdf')
  
end;

{ refactor: устанавливать для просмотра файл из SelectedDocumentFileInfo,
  если TargetDocumentFilePath = '' }
procedure TDocumentFilesViewFrame.OnDocumentFileInfoSelectionChanged(
  SelectedDocumentFileInfo: TDocumentFileInfo
);
var
    TargetDocumentFilePath: String;
begin

  RaiseOnDocumentFileShowingEventHandler(
    SelectedDocumentFileInfo, TargetDocumentFilePath
  );

  if Trim(TargetDocumentFilePath) = '' then Exit;
  
  ShowDocumentFileInViewArea(TargetDocumentFilePath);

end;

procedure TDocumentFilesViewFrame.RaiseOnDocumentFileInfoItemSelectionChangedIfNecessary;
begin

  if (DocumentFilesListBox.Count > 0) and
     (DocumentFilesListBox.ItemIndex >= 0)
  then begin

    if (FCurrentDocumentFileInfo =
       GetDocumentFileInfoByItemIndex(DocumentFilesListBox.ItemIndex)) and
       FPDFViewForm.IsDocumentLoaded
    then Exit;

    FCurrentDocumentFileInfo :=
      GetDocumentFileInfoByItemIndex(DocumentFilesListBox.ItemIndex);

    if FErrorFileList.IndexOf(FCurrentDocumentFileInfo.FilePath) = -1
    then begin
    
      OnDocumentFileInfoSelectionChanged(
        FCurrentDocumentFileInfo
      );

    end;

  end

  else FPDFViewForm.ClearDocument;

end;

procedure TDocumentFilesViewFrame.RaiseOnDocumentFileShowingEventHandler(
  ShowableDocumentFileInfo: TDocumentFileInfo;
  var TargetDocumentFilePath: String
);
begin

  if not Assigned(FOnDocumentFileShowingEventHandler) then Exit;

  try

    TargetDocumentFilePath := ShowableDocumentFileInfo.FilePath;

    FOnDocumentFileShowingEventHandler(
      Self,
      ShowableDocumentFileInfo,
      TargetDocumentFilePath
    );

    if TargetDocumentFilePath = '' then
      FErrorFileList.Add(ShowableDocumentFileInfo.FilePath);

  except

    FErrorFileList.Add(ShowableDocumentFileInfo.FilePath);

    Raise;

  end;

end;

procedure TDocumentFilesViewFrame.RemoveDocumentFileInfo(const FileName: String);
var
    DocumentFileInfoIndex: Integer;
    ErrorFileIndex: Integer;
begin

  DocumentFileInfoIndex := FDocumentFileInfoList.IndexOf(FileName);

  if DocumentFileInfoIndex = -1 then Exit;

  FDocumentFileInfoList.Delete(DocumentFileInfoIndex);

  ErrorFileIndex := FErrorFileList.IndexOf(FileName);

  if ErrorFileIndex <> -1 then
    FErrorFileList.Delete(ErrorFileIndex);
    
  RemoveDocumentFileInfoItemFromListBox(DocumentFileInfoIndex);

  if EnableUIAndDocumentFileInfoSynchronization then
    RaiseOnDocumentFileInfoItemSelectionChangedIfNecessary;

end;

procedure TDocumentFilesViewFrame.RemoveDocumentFileInfoItemFromListBox(
  const ItemIndex: Integer);
var LastItemIndex: Integer;
    NewFocusedItemIndex: Integer;
begin

  LastItemIndex := DocumentFilesListBox.Count - 1;
  
  DocumentFilesListBox.Items.Delete(ItemIndex);

  if

     (DocumentFilesListBox.ItemIndex = -1) and
     (DocumentFilesListBox.Count > 0)

  then begin

    if ItemIndex = LastItemIndex then
      NewFocusedItemIndex := ItemIndex - 1

    else NewFocusedItemIndex := ItemIndex;

    DocumentFilesListBox.ItemIndex := NewFocusedItemIndex;
    
  end;
  
end;

procedure TDocumentFilesViewFrame.SetCurrentDocumentFileName(
  const Value: String);
var
    ItemIndex: Integer;
begin

  ItemIndex := DocumentFilesListBox.Items.IndexOf(Value);

  if ItemIndex <> -1 then
    DocumentFilesListBox.ItemIndex := ItemIndex;

  RaiseOnDocumentFileInfoItemSelectionChangedIfNecessary;
  
end;

procedure TDocumentFilesViewFrame.SetDocumentFileInfoList(
  DocumentFileInfoList: TDocumentFileInfoList);
begin

  if not Assigned(DocumentFileInfoList) then
    Exit;

  FreeAndNil(FDocumentFileInfoList);

  FDocumentFileInfoList := DocumentFileInfoList;

  FillDocumentFileInfoListBox;

  FErrorFileList.Clear;

  DocumentFilesListBox.ItemIndex := 0;

  if EnableUIAndDocumentFileInfoSynchronization then
    RaiseOnDocumentFileInfoItemSelectionChangedIfNecessary;
  
end;

procedure TDocumentFilesViewFrame.SetDocumentFileListVisible(
  const Value: Boolean);
begin

  DocumentFileListPanel.Visible := Value;
  DocumentFilesListBox.Visible := Value;
  SplitterBetweenDocumentFileListPanelAndDocumentFileViewArea.Visible := Value;
  
end;

procedure TDocumentFilesViewFrame.
  SetEnableUIAndDocumentFileInfoSynchronization(
    Value: Boolean
  );
begin

  FEnableUIAndDocumentFileInfoSynchronization := Value;

end;

procedure TDocumentFilesViewFrame.SetPDFViewForm(const Value: TPDFViewForm);
begin

  Initialize(Value, EnableUIAndDocumentFileInfoSynchronization);

end;

procedure TDocumentFilesViewFrame.SetStyleToControls;
begin

  Color := TDocumentFlowCommonControlStyles.GetFormBackgroundColor;
  
  SplitterBetweenDocumentFileListPanelAndDocumentFileViewArea.Color :=
    TDocumentFlowCommonControlStyles.GetSplitterColor;

  FPDFViewForm.Color := TDocumentFlowCommonControlStyles.GetFormBackgroundColor;
  
  FPDFViewForm.ButtonsColor :=
    TDocumentFlowCommonControlStyles.GetButtonBackgroundColor;

  FPDFViewForm.CounterClockwiseRotateDocumentButton.Colors.Default := clWhite;
  FPDFViewForm.ClockwiseRotateDocumentButton.Colors.Default := clWhite;

  FPDFViewForm.ShowFirstDocumentPageButton.Colors.Default := clWhite;
  FPDFViewForm.ShowLastDocumentPageButton.Colors.Default := clWhite;
  FPDFViewForm.btnNextDocument.Colors.Default := clWhite;
  FPDFViewForm.btnPrevDocument.Colors.Default := clWhite;

end;

procedure TDocumentFilesViewFrame.SetViewOnly(const Value: Boolean);
begin


end;

procedure TDocumentFilesViewFrame.ShowDocumentFileInViewArea(
  const FilePath: String);
begin

  FPDFViewForm.LoadAndShowDocument(FilePath);
  
end;

procedure TDocumentFilesViewFrame.
  SynchronizeUIWithCurrentDocumentFileInfoIfNecessary;
begin

  RaiseOnDocumentFileInfoItemSelectionChangedIfNecessary;

end;

end.
