unit DocumentRelationsFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unDocumentCardInformationFrame, ExtCtrls, StdCtrls,
  DBDataTableFormUnit,
  DocumentRelationsReferenceFormUnit,
  DocumentRelationsFormViewModelUnit,
  DB;

type

  TOnDocumentSelectionFormRequestedEventHandler =
    procedure (
      Sender: TObject;
      var DocumentSelectionForm: TForm
    ) of object;
    
  TOnRelatedDocumentCardOpeningRequestedEventHandler =
    procedure (
      Sender: TObject;
      const DocumentId, DocumentKindId: Variant
    ) of object;
    
  TDocumentRelationsFrame = class(TDocumentCardInformationFrame)
    { Private declarations }

  protected

    procedure Initialize; override;

  protected

    FIsDocumentRelationsDataSetChanged: Boolean;
    FViewModel: TDocumentRelationsFormViewModel;

    FOnRelatedDocumentCardOpeningRequestedEventHandler:
      TOnRelatedDocumentCardOpeningRequestedEventHandler;
      
    FDocumentRelationsTableForm: TDocumentRelationsReferenceForm;

    procedure SetEnabled(Value: Boolean); override;
    
    procedure OnDocumentRelationsChangedEventHandler(
      DataSet: TDataSet
    );

    procedure OnDocumentRelationsRemovedEventHandler(
      DataSet: TDataSet
    );

    procedure OnDocumentRelationsRefreshedEventHandler(
      DataSet: TDataSet
    );

    procedure OnRelatedDocumentCardOpeningFromDocumentRelationsTableRequestedEventHandler(
      Sender: TObject;
      SelectedDocumentRelationTableRecord: TDocumentRelationTableRecord
    );

    procedure SubscribeOnDocumentRelationsDataSetDataEvents;

    function GetViewModelClass: TDocumentRelationsPageViewModelClass; virtual;

    function GetViewModel: TDocumentRelationsFormViewModel; virtual;
    procedure SetViewModel(ViewModel: TDocumentRelationsFormViewModel); virtual;

    procedure FillUIElementsFromViewModel;

    procedure SetWorkingEmployeeId(const Value: Variant); override;

    procedure AssignEventHandlersToDocumentRelationsTable(
      DocumentRelationsTableForm: TDocumentRelationsReferenceForm
    );
    
    function GetOnDocumentSelectionRequestedFormEventHandler: TOnDocumentSelectionFormRequestedEventHandler;
    procedure SetOnDocumentSelectionRequestedFormEventHandler(
      const Value: TOnDocumentSelectionFormRequestedEventHandler);

    function GetViewOnly: Boolean; override;
    procedure SetViewOnly(const Value: Boolean); override;

    procedure SetFont(const Value: TFont); override;

  public

    destructor Destroy; override;
    constructor Create(AOwner: TComponent); override;

    procedure OnChangesApplied; override;
    procedure OnChangesApplyingFailed; override;
    function IsDataChanged: Boolean; override;

    procedure AssignDocumentRelationsTableForm(
      DocumentRelationsTableForm: TDocumentRelationsReferenceForm
    );

    property ViewModel: TDocumentRelationsFormViewModel
    read GetViewModel write SetViewModel;

    property DocumentRelationsTableForm: TDocumentRelationsReferenceForm
    read FDocumentRelationsTableForm;
    
    property OnDocumentSelectionRequestedFormEventHandler:
      TOnDocumentSelectionFormRequestedEventHandler

    read GetOnDocumentSelectionRequestedFormEventHandler
    write SetOnDocumentSelectionRequestedFormEventHandler;

    property OnRelatedDocumentCardOpeningRequestedEventHandler:
      TOnRelatedDocumentCardOpeningRequestedEventHandler
    read FOnRelatedDocumentCardOpeningRequestedEventHandler
    write FOnRelatedDocumentCardOpeningRequestedEventHandler;
    
  end;

var
  DocumentRelationsFrame: TDocumentRelationsFrame;

implementation

{$R *.dfm}

uses

  AuxDebugFunctionsUnit;

{ TDocumentRelationsFrame }

procedure TDocumentRelationsFrame.AssignDocumentRelationsTableForm(
  DocumentRelationsTableForm: TDocumentRelationsReferenceForm);
begin

  FreeAndNil(FDocumentRelationsTableForm);

  FDocumentRelationsTableForm := DocumentRelationsTableForm;
  FDocumentRelationsTableForm.Parent := DocumentInfoPanel;
  FDocumentRelationsTableForm.Align := alClient;
  FDocumentRelationsTableForm.BorderStyle := bsNone;
  FDocumentRelationsTableForm.Font := Font;
  
  AssignEventHandlersToDocumentRelationsTable(FDocumentRelationsTableForm);
  
  FDocumentRelationsTableForm.Show;

end;

procedure TDocumentRelationsFrame.AssignEventHandlersToDocumentRelationsTable(
  DocumentRelationsTableForm: TDocumentRelationsReferenceForm);
begin

  DocumentRelationsTableForm.
    OnRelatedDocumentCardOpeningRequestedEventHandler :=
      OnRelatedDocumentCardOpeningFromDocumentRelationsTableRequestedEventHandler;
      
end;

constructor TDocumentRelationsFrame.Create(AOwner: TComponent);
begin

  inherited;

end;

destructor TDocumentRelationsFrame.Destroy;
begin

  if Assigned(FDocumentRelationsTableForm) then begin

    FDocumentRelationsTableForm.Parent.RemoveControl(
      FDocumentRelationsTableForm
    );

    if Assigned(FDocumentRelationsTableForm.Owner) then begin

      FDocumentRelationsTableForm.Owner.RemoveComponent(
        FDocumentRelationsTableForm
      );

    end;

    FDocumentRelationsTableForm.SafeDestroy;
    
  end;
  
  inherited;

end;

procedure TDocumentRelationsFrame.FillUIElementsFromViewModel;
begin

  FDocumentRelationsTableForm.DocumentRelationSetHolder :=
    FViewModel.DocumentRelationSetHolder;

  SubscribeOnDocumentRelationsDataSetDataEvents;
  
end;

function TDocumentRelationsFrame.
  GetOnDocumentSelectionRequestedFormEventHandler:
    TOnDocumentSelectionFormRequestedEventHandler;
begin

  if Assigned(FDocumentRelationsTableForm) then
    Result := FDocumentRelationsTableForm.OnDocumentSelectionFormRequestedEventHandler

  else Result := nil;
  
end;

function TDocumentRelationsFrame.GetViewModel: TDocumentRelationsFormViewModel;
begin

  FViewModel.DocumentRelationSetHolder :=
    FDocumentRelationsTableForm.DocumentRelationSetHolder;

  Result := FViewModel;

end;

function TDocumentRelationsFrame.GetViewModelClass: TDocumentRelationsPageViewModelClass;
begin

  Result := TDocumentRelationsFormViewModel;
  
end;

function TDocumentRelationsFrame.GetViewOnly: Boolean;
begin

 Result := inherited GetViewOnly;
  
end;

procedure TDocumentRelationsFrame.Initialize;
begin

  inherited Initialize;

  EnableScrolling := False;

end;

function TDocumentRelationsFrame.IsDataChanged: Boolean;
begin

  Result := FIsDocumentRelationsDataSetChanged;

end;

procedure TDocumentRelationsFrame.OnDocumentRelationsChangedEventHandler(
  DataSet: TDataSet);
begin

  FIsDocumentRelationsDataSetChanged := True;

end;

procedure TDocumentRelationsFrame.OnDocumentRelationsRefreshedEventHandler(
  DataSet: TDataSet);
begin

  FIsDocumentRelationsDataSetChanged := False;
  
end;

procedure TDocumentRelationsFrame.OnDocumentRelationsRemovedEventHandler(
  DataSet: TDataSet);
begin

  FIsDocumentRelationsDataSetChanged := True;
  
end;

procedure TDocumentRelationsFrame.
  OnRelatedDocumentCardOpeningFromDocumentRelationsTableRequestedEventHandler(
    Sender: TObject;
    SelectedDocumentRelationTableRecord: TDocumentRelationTableRecord
  );
begin

  if Assigned(FOnRelatedDocumentCardOpeningRequestedEventHandler) then begin

    FOnRelatedDocumentCardOpeningRequestedEventHandler(
      Self,
      SelectedDocumentRelationTableRecord.DocumentId,
      SelectedDocumentRelationTableRecord.DocumentKindId
    );

  end;

end;

procedure TDocumentRelationsFrame.OnChangesApplied;
begin

  FIsDocumentRelationsDataSetChanged := False;

end;

procedure TDocumentRelationsFrame.OnChangesApplyingFailed;
begin

  inherited;

end;

procedure TDocumentRelationsFrame.SetEnabled(Value: Boolean);
begin

  inherited;

end;

procedure TDocumentRelationsFrame.SetFont(const Value: TFont);
begin

  inherited;

  if Assigned(FDocumentRelationsTableForm) then
    FDocumentRelationsTableForm.Font := Value;
    
end;

procedure TDocumentRelationsFrame.SetOnDocumentSelectionRequestedFormEventHandler(
  const Value: TOnDocumentSelectionFormRequestedEventHandler);
begin

  if Assigned(FDocumentRelationsTableForm) then
    FDocumentRelationsTableForm.
      OnDocumentSelectionFormRequestedEventHandler := Value;
      
end;

procedure TDocumentRelationsFrame.SetViewModel(
  ViewModel: TDocumentRelationsFormViewModel);
begin

  FViewModel := ViewModel;

  FillUIElementsFromViewModel;
  
end;

procedure TDocumentRelationsFrame.SetViewOnly(const Value: Boolean);
begin

  FDocumentRelationsTableForm.ViewOnly := Value;
  
end;

procedure TDocumentRelationsFrame.SetWorkingEmployeeId(const Value: Variant);
begin

  inherited;

  FDocumentRelationsTableForm.EmployeeId := Value;
  
end;

procedure TDocumentRelationsFrame.SubscribeOnDocumentRelationsDataSetDataEvents;
begin

  with FDocumentRelationsTableForm.DataSet do begin

    AfterPost := OnDocumentRelationsChangedEventHandler;
    AfterDelete := OnDocumentRelationsRemovedEventHandler;
    AfterRefresh := OnDocumentRelationsRefreshedEventHandler;
    
  end;
  
end;

end.
