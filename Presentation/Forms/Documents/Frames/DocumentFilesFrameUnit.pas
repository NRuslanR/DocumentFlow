unit DocumentFilesFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unDocumentCardInformationFrame, ExtCtrls,
  DocumentFilesReferenceFormUnit,
  DB,
  DocumentFilesFormViewModelUnit,
  DocumentFileInfoList,
  dxmdaset;

type

  TOnDocumentFileAddedEventHandler =
    procedure (
      Sender: TObject;
      const FileName: String;
      const FilePath: String
    ) of object;

  TOnDocumentFileRemovedEventHandler =
    procedure (
      Sender: TObject;
      const FileName: String;
      const FilePath: String
    ) of object;

  TOnDocumentFileSelectedEventHandler =
    procedure (
      Sender: TObject;
      const FileId: Variant;
      const FileName: String
    ) of object;

  TDocumentFilesFrame = class(TDocumentCardInformationFrame)

  protected

    FOnDocumentFileAddedEventHandler: TOnDocumentFileAddedEventHandler;
    FOnDocumentFileRemovedEventHandler: TOnDocumentFileRemovedEventHandler;
    FOnDocumentFileSelectedEventHandler: TOnDocumentFileSelectedEventHandler;

  protected

    procedure Initialize; override;
    
  protected

    FIsDocumentFilesDataSetChanged: Boolean;
    FViewModel: TDocumentFilesFormViewModel;
    FDocumentFilesTableForm: TDocumentFilesReferenceForm;

    procedure SetEnabled(Value: Boolean); override;

    procedure OnDocumentFileTableRecordAddedEventHandler(
      Sender: TObject;
      AddedDocumentFileTableRecord: TDocumentFileTableRecord
    );

    procedure OnDocumentFileTableRecordRemovedEventHandler(
      Sender: TObject;
      RemovedDocumentFileTableRecord: TDocumentFileTableRecord
    );

    procedure OnDocumentFileRecordFocusedEventHandler(
      Sender: TObject;
      FocusedDocumentFileRecord: TDocumentFileTableRecord
    );

    procedure OnDocumentFilesRefreshedEventHandler(
      DataSet: TDataSet
    );

    procedure SubscribeOnDocumentFilesTableEvents;

    function GetViewModelClass: TDocumentFilesPageViewModelClass; virtual;

    function GetViewModel: TDocumentFilesFormViewModel; virtual;
    procedure SetViewModel(
      ViewModel: TDocumentFilesFormViewModel
    ); virtual;

    procedure FillUIElementsFromViewModel;

    function GetOnExistingDocumentFileOpeningRequestedEventHandler:
      TOnExistingDocumentFileOpeningRequestedEventHandler;

    procedure SetOnExistingDocumentFileOpeningRequestedEventHandler(
      Value: TOnExistingDocumentFileOpeningRequestedEventHandler
    );

    function GetViewOnly: Boolean; override;
    procedure SetViewOnly(const Value: Boolean); override;

  protected

    procedure SetFont(const Value: TFont); override;

  public
    { Public declarations }

    destructor Destroy; override;

    procedure OnChangesApplied; override;
    procedure OnChangesApplyingFailed; override;
    function IsDataChanged: Boolean; override;

    procedure AssignDocumentFilesTableForm(
      DocumentFilesTableForm: TDocumentFilesReferenceForm
    );

    function GetCurrentDocumentFileInfo: TDocumentFileInfo;
    
    property ViewModel: TDocumentFilesFormViewModel
    read GetViewModel write SetViewModel;

    property OnExistingDocumentFileOpeningRequestedEventHandler:
      TOnExistingDocumentFileOpeningRequestedEventHandler

    read GetOnExistingDocumentFileOpeningRequestedEventHandler
    write SetOnExistingDocumentFileOpeningRequestedEventHandler;

    property OnDocumentFileSelectedEventHandler: TOnDocumentFileSelectedEventHandler
    read FOnDocumentFileSelectedEventHandler write FOnDocumentFileSelectedEventHandler;

    property DocumentFilesTableForm: TDocumentFilesReferenceForm
    read FDocumentFilesTableForm;
    
    property OnDocumentFileAddedEventHandler:
      TOnDocumentFileAddedEventHandler
    read FOnDocumentFileAddedEventHandler
    write FOnDocumentFileAddedEventHandler;

    property OnDocumentFileRemovedEventHandler:
      TOnDocumentFileRemovedEventHandler
    read FOnDocumentFileRemovedEventHandler
    write FOnDocumentFileRemovedEventHandler;

  end;

var
  DocumentFilesFrame: TDocumentFilesFrame;

implementation

{$R *.dfm}

uses

  AuxDebugFunctionsUnit,
  UIDocumentKinds,
  DocumentFileSetHolder;
  
{ TDocumentFilesFrame }

procedure TDocumentFilesFrame.AssignDocumentFilesTableForm(
  DocumentFilesTableForm: TDocumentFilesReferenceForm);
begin

  FreeAndNil(FDocumentFilesTableForm);

  FDocumentFilesTableForm := DocumentFilesTableForm;
  FDocumentFilesTableForm.Parent := DocumentInfoPanel;
  FDocumentFilesTableForm.Align := alClient;
  FDocumentFilesTableForm.BorderStyle := bsNone;
  FDocumentFilesTableForm.Font := Font;
  
  FDocumentFilesTableForm.Show;
  
end;

destructor TDocumentFilesFrame.Destroy;
begin

  if Assigned(FDocumentFilesTableForm) then begin

    FDocumentFilesTableForm.Parent.RemoveControl(
      FDocumentFilesTableForm
    );

    if Assigned(FDocumentFilesTableForm.Owner) then begin

      FDocumentFilesTableForm.Owner.RemoveComponent(
        FDocumentFilesTableForm
      );

    end;

    FDocumentFilesTableForm.SafeDestroy;
    
  end;

  inherited;

end;

procedure TDocumentFilesFrame.FillUIElementsFromViewModel;
begin

  FDocumentFilesTableForm.DocumentFileSetHolder :=
    FViewModel.DocumentFileSetHolder;

  SubscribeOnDocumentFilesTableEvents;

end;

function TDocumentFilesFrame.GetCurrentDocumentFileInfo: TDocumentFileInfo;
var
    FocusedDocumentFileRecord: TDocumentFileTableRecord;
begin

  if not Assigned(FDocumentFilesTableForm) then begin

    Result := nil;
    Exit;

  end;

  FocusedDocumentFileRecord := FDocumentFilesTableForm.FocusedDocumentFileRecord;

  if not Assigned(FocusedDocumentFileRecord) then begin

    Result := nil;
    Exit;

  end;

  try

    Result :=
      TDocumentFileInfo.Create(
        FocusedDocumentFileRecord.DocumentFileId,
        FocusedDocumentFileRecord.DocumentFileName,
        FocusedDocumentFileRecord.DocumentFilePath
      );
      
  finally

    FreeAndNil(FocusedDocumentFileRecord);

  end;

end;

function TDocumentFilesFrame.GetOnExistingDocumentFileOpeningRequestedEventHandler: TOnExistingDocumentFileOpeningRequestedEventHandler;
begin

  Result := FDocumentFilesTableForm.OnExistingDocumentFileOpeningRequestedEventHandler;
  
end;

function TDocumentFilesFrame.GetViewModel: TDocumentFilesFormViewModel;
begin

  FViewModel.DocumentFileSetHolder :=
    FDocumentFilesTableForm.DocumentFileSetHolder;

  Result := FViewModel;

end;

function TDocumentFilesFrame.GetViewModelClass: TDocumentFilesPageViewModelClass;
begin

  Result := TDocumentFilesFormViewModel;

end;

function TDocumentFilesFrame.GetViewOnly: Boolean;
begin

  Result := inherited GetViewOnly;
  
end;

procedure TDocumentFilesFrame.Initialize;
begin

  inherited Initialize;

  EnableScrolling := False;
  
end;

function TDocumentFilesFrame.IsDataChanged: Boolean;
begin

  Result := FIsDocumentFilesDataSetChanged;

end;

procedure TDocumentFilesFrame.OnDocumentFileRecordFocusedEventHandler(
  Sender: TObject;
  FocusedDocumentFileRecord: TDocumentFileTableRecord
);
begin

  if Assigned(FOnDocumentFileSelectedEventHandler) then begin

    FOnDocumentFileSelectedEventHandler(
      Self,
      FocusedDocumentFileRecord.DocumentFileId,
      FocusedDocumentFileRecord.DocumentFileName
    );
    
  end;

end;

procedure TDocumentFilesFrame.OnDocumentFilesRefreshedEventHandler(
  DataSet: TDataSet);
begin

  FIsDocumentFilesDataSetChanged := False;
  
end;


procedure TDocumentFilesFrame.OnDocumentFileTableRecordAddedEventHandler(
  Sender: TObject; AddedDocumentFileTableRecord: TDocumentFileTableRecord);
begin

  FIsDocumentFilesDataSetChanged := True;

  if Assigned(FOnDocumentFileAddedEventHandler) then
    FOnDocumentFileAddedEventHandler(
      Self,
      AddedDocumentFileTableRecord.DocumentFileName,
      AddedDocumentFileTableRecord.DocumentFilePath
    );

end;

procedure TDocumentFilesFrame.OnDocumentFileTableRecordRemovedEventHandler(
  Sender: TObject; RemovedDocumentFileTableRecord: TDocumentFileTableRecord);
begin

  FIsDocumentFilesDataSetChanged := True;

  if Assigned(FOnDocumentFileRemovedEventHandler) then
    FOnDocumentFileRemovedEventHandler(
      Self,
      RemovedDocumentFileTableRecord.DocumentFileName,
      RemovedDocumentFileTableRecord.DocumentFilePath
    );
    
end;

procedure TDocumentFilesFrame.OnChangesApplied;
begin

  FIsDocumentFilesDataSetChanged := False;

end;

procedure TDocumentFilesFrame.OnChangesApplyingFailed;
begin

  inherited;

end;

{ refactor }

procedure TDocumentFilesFrame.SetEnabled(Value: Boolean);
begin

  inherited;
  
end;

procedure TDocumentFilesFrame.SetFont(const Value: TFont);
begin

  inherited;

  if Assigned(FDocumentFilesTableForm) then
    FDocumentFilesTableForm.Font := Value;
    
end;

procedure TDocumentFilesFrame.SetOnExistingDocumentFileOpeningRequestedEventHandler(
  Value: TOnExistingDocumentFileOpeningRequestedEventHandler);
begin

  if Assigned(FDocumentFilesTableForm) then
    FDocumentFilesTableForm.OnExistingDocumentFileOpeningRequestedEventHandler := Value;
  
end;

procedure TDocumentFilesFrame.SetViewModel(
  ViewModel: TDocumentFilesFormViewModel
);
begin

  FViewModel := ViewModel;

  FillUIElementsFromViewModel;
  
end;

procedure TDocumentFilesFrame.SetViewOnly(const Value: Boolean);
begin

  FDocumentFilesTableForm.ViewOnly := Value;
  
end;

procedure TDocumentFilesFrame.SubscribeOnDocumentFilesTableEvents;
begin

  if not Assigned(FDocumentFilesTableForm) then
    Exit;
  
  FDocumentFilesTableForm.OnDocumentFileRecordRemovedEventHandler :=
    OnDocumentFileTableRecordRemovedEventHandler;

  FDocumentFilesTableForm.OnDocumentFileRecordAddedEventHandler :=
    OnDocumentFileTableRecordAddedEventHandler;

  FDocumentFilesTableForm.OnDocumentFileRecordFocusedEventHandler :=
    OnDocumentFileRecordFocusedEventHandler;

  FDocumentFilesTableForm.DataSet.AfterRefresh :=
    OnDocumentFilesRefreshedEventHandler;
    
end;

end.
