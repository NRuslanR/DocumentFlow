unit DocumentSelectionFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  DocumentFlowWorkingFormUnit, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxCustomData, cxStyles, cxTL, cxMaskEdit,
  cxTLdxBarBuiltInMenu, dxSkinsCore, dxSkinsDefaultPainters,
  cxInplaceContainer,
  cxDBTL, cxTLData, StdCtrls, ExtCtrls,
  BaseEmployeeDocumentsReferenceFormUnit,
  unDocumentCardFrame,
  EmployeeDocumentTableRecord,
  DB, DBDataTableFormUnit;

type
  TDocumentSelectionForm = class(TDocumentFlowWorkingForm)
  private

    function GetSelectedDocumentRecords: TEmployeeDocumentTableRecords;
    { Private declarations }

  protected

    procedure OnDocumentsChoosedEventHandler(
      Sender: TObject;
      SelectedDocumentRecords: TDBDataTableRecords
    );
    
    procedure CustomizeBaseEmployeeDocumentsReferenceForm(
      EmployeeDocumentReferenceForm: TBaseEmployeeDocumentsReferenceForm
    ); override;

    procedure CustomizeDocumentCardFrame(
      DocumentCardFrame: TDocumentCardFrame
    ); override;

    procedure CloseSuccessfully;
    
  public
    { Public declarations }

    destructor Destroy; override;
    constructor Create(AOwner: TComponent); overload; override;

    property SelectedDocumentRecords: TEmployeeDocumentTableRecords
    read GetSelectedDocumentRecords;

  end;

implementation

{$R *.dfm}

{ TDocumentSelectionForm }

constructor TDocumentSelectionForm.Create(AOwner: TComponent);
begin

  inherited;

end;

procedure TDocumentSelectionForm.CloseSuccessfully;
begin

  if fsModal in FFormState then begin

    ModalResult := mrOk;
    CloseModal;

  end

  else Close;

end;

procedure TDocumentSelectionForm.CustomizeDocumentCardFrame(
  DocumentCardFrame: TDocumentCardFrame);
begin

  inherited;

  DocumentCardFrame.ViewOnly := True;
  
end;

procedure TDocumentSelectionForm.CustomizeBaseEmployeeDocumentsReferenceForm(
  EmployeeDocumentReferenceForm: TBaseEmployeeDocumentsReferenceForm);
begin

  inherited;

  EmployeeDocumentReferenceForm.ViewOnly := True;
  EmployeeDocumentReferenceForm.ChooseRecordActionVisible := True;
  EmployeeDocumentReferenceForm.OnRecordsChoosedEventHandler :=
    OnDocumentsChoosedEventHandler;
    
end;

destructor TDocumentSelectionForm.Destroy;
begin

  FDocumentDataSetHoldersFactory := nil;
  FEmployeeDocumentsReferenceFormFactory := nil;
  FDocumentTypesPanelController := nil;
  
  inherited;

end;

function TDocumentSelectionForm.
  GetSelectedDocumentRecords: TEmployeeDocumentTableRecords;
begin

  Result := FBaseEmployeeDocumentsReferenceForm.SelectedDocumentRecords;
  
end;

procedure TDocumentSelectionForm.OnDocumentsChoosedEventHandler(
  Sender: TObject;
  SelectedDocumentRecords: TDBDataTableRecords
);
begin

  CloseSuccessfully;
  
end;

end.
