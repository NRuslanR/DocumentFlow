{ refactor: вынести RuleRegistry в BusinessProcessesServiceRegistry,
  в прикладные службы передавать только набор правил, а не его реестр }
unit DocumentOperationService;

interface

uses

  SysUtils,
  Classes,
  Document,
  DocumentDirectory,
  IDocumentUnit,
  EmployeeDocumentWorkingRules,
  VariantListUnit,
  BusinessProcessService,
  Session;

type

  TDocumentOperationService = class abstract (TBusinessProcessService)

    protected

      FDocumentDirectory: IDocumentDirectory;

      function GetDocument(
        const DocumentId: Variant
      ): IDocument; virtual;

      function GetDocumentOrRaise(
        const DocumentId: Variant;
        const ErrorMessage: String = ''
      ): IDocument;

      function GetDocuments(
        const DocumentIds: TVariantList
      ): TDocuments; virtual;
      
      procedure SaveDocumentChangesToRepository(
        Document: TDocument
      ); virtual;

    protected
      
      constructor Create(
        Session: ISession;
        DocumentDirectory: IDocumentDirectory
      );

  end;

implementation

uses

  StrUtils,
  AbstractApplicationService,
  DocumentRuleRegistry;

{ TDocumentOperationService }

constructor TDocumentOperationService.Create(
  Session: ISession;
  DocumentDirectory: IDocumentDirectory
);
begin

  inherited Create(Session);

  FDocumentDirectory := DocumentDirectory;

end;

function TDocumentOperationService.GetDocument(
  const DocumentId: Variant
): IDocument;
begin

  Result := FDocumentDirectory.FindDocumentById(DocumentId);

  if not Assigned(Result) then
    RaiseFailedBusinessProcessServiceException('Документ не найден');

end;

function TDocumentOperationService.GetDocumentOrRaise(const DocumentId: Variant;
  const ErrorMessage: String): IDocument;
begin

  try

    Result := GetDocument(DocumentId);

  except

    on E: TBusinessProcessServiceException do begin

      RaiseFailedBusinessProcessServiceException(
        IfThen(Trim(ErrorMessage) = '', E.Message, ErrorMessage)
      );

    end;

  end;

end;

function TDocumentOperationService.GetDocuments(
  const DocumentIds: TVariantList
): TDocuments;
var
    ErrorMessage: String;
begin

  Result := FDocumentDirectory.FindDocumentsByIds(DocumentIds);

  if not Assigned(Result) then begin

    if DocumentIds.Count = 1 then
      ErrorMessage := 'Документ не найден'

    else ErrorMessage := 'Документы не найдены';

    RaiseFailedBusinessProcessServiceException(ErrorMessage);

  end;

end;

procedure TDocumentOperationService.SaveDocumentChangesToRepository(
  Document: TDocument);
begin

  FDocumentDirectory.ModifyDocument(Document);
  
end;

end.
