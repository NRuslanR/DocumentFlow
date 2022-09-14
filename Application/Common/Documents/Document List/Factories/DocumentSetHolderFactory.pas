unit DocumentSetHolderFactory;

interface

uses

  DocumentSetHolder,
  SysUtils;

type

  TDocumentSetHolderFactory = class

    protected

      function CreateDocumentSetHolderInstance: TDocumentSetHolder; virtual;
      procedure FillDocumentSetFieldDefs(DocumentSetHolder: TDocumentSetHolder); virtual;

    public

      destructor Destroy; override;
      constructor Create; virtual;
      
      function CreateDocumentSetHolder: TDocumentSetHolder; 
      
  end;

  TDocumentSetHolderFactoryClass = class of TDocumentSetHolderFactory;
  
implementation

uses

  DocumentsViewDef;
  
{ TDocumentSetHolderFactory }

constructor TDocumentSetHolderFactory.Create;
begin

  inherited;
  
end;

function TDocumentSetHolderFactory.
  CreateDocumentSetHolder: TDocumentSetHolder;
begin

  Result := CreateDocumentSetHolderInstance;

  try

    FillDocumentSetFieldDefs(Result);

  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;

    end;
    
  end;

end;

function TDocumentSetHolderFactory.CreateDocumentSetHolderInstance: TDocumentSetHolder;
begin

  Result := TDocumentSetHolder.Create;
  
end;

destructor TDocumentSetHolderFactory.Destroy;
begin

  inherited;

end;

procedure TDocumentSetHolderFactory.
  FillDocumentSetFieldDefs(DocumentSetHolder: TDocumentSetHolder);
begin

  with DocumentSetHolder do begin

    DocumentIdFieldName := DOCUMENT_VIEW_ID_FIELD;
    BaseDocumentIdFieldName := DOCUMENT_VIEW_BASE_DOCUMENT_ID_FIELD;
    KindFieldName := DOCUMENT_VIEW_KIND_NAME_FIELD;
    KindIdFieldName := DOCUMENT_VIEW_KIND_ID_FIELD;
    CreationDateFieldName := DOCUMENT_VIEW_CREATION_DATE_FIELD;
    DocumentDateFieldName := DOCUMENT_VIEW_DOCUMENT_DATE_FIELD;
    CreationDateYearFieldName := DOCUMENT_VIEW_CREATION_DATE_YEAR_FIELD;
    CreationDateMonthFieldName := DOCUMENT_VIEW_CREATION_DATE_MONTH_FIELD;
    CurrentWorkCycleStageNumberFieldName := DOCUMENT_VIEW_CURRENT_WORK_CYCLE_STAGE_NUMBER_FIELD;
    CurrentWorkCycleStageNameFieldName := DOCUMENT_VIEW_CURRENT_WORK_CYCLE_STAGE_NAME_FIELD;
    NumberFieldName := DOCUMENT_VIEW_NUMBER_FIELD;
    NameFieldName := DOCUMENT_VIEW_NAME_FIELD;
    AuthorIdFieldName := DOCUMENT_VIEW_AUTHOR_ID_FIELD;
    AuthorNameFieldName := DOCUMENT_VIEW_AUTHOR_NAME_FIELD;
    ChargePerformingStatisticsFieldName := DOCUMENT_VIEW_CHARGE_PERFORMING_STATISTICS_FIELD;
    IsSelfRegisteredFieldName := DOCUMENT_VIEW_IS_SELF_REGISTERED_FIELD;
    CanBeRemovedFieldName := DOCUMENT_VIEW_CAN_BE_REMOVED_FIELD;
    AreApplicationsExistsFieldName := DOCUMENT_VIEW_ARE_APPLICATIONS_EXISTS_FIELD;
    ProductCodeFieldName := DOCUMENT_VIEW_PRODUCT_CODE_FIELD;

  end;
  
end;

end.
