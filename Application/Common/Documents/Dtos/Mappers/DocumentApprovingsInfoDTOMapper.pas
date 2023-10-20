unit DocumentApprovingsInfoDTOMapper;

interface

uses

  DocumentFlowEmployeeInfoDTOMapper,
  DocumentViewingAccountingService,
  IEmployeeRepositoryUnit,
  Employee,
  DocumentFullInfoDTO,
  Document,
  DocumentApprovings,
  Disposable,
  SysUtils,
  Classes;

type

  TDocumentApprovingsInfoDTOMapper = class (TInterfacedObject, IDisposable)

    protected

      FEmployeeRepository: IEmployeeRepository;
      FDocumentViewingAccountingService: IDocumentViewingAccountingService;

      FDocumentFlowEmployeeInfoDTOMapper: TDocumentFlowEmployeeInfoDTOMapper;
      FFreeDocumentFlowEmployeeInfoDTOMapper: IDisposable;
      
    protected

      function MapDocumentApprovingInfoDTO(
        Document: TDocument;
        DocumentApproving: TDocumentApproving;
        AccessingEmployee: TEmployee = nil
      ): TDocumentApprovingInfoDTO; virtual;

      procedure FillDocumentApprovingInfoDTOFrom(
        DocumentApprovingInfoDTO: TDocumentApprovingInfoDTO;
        DocumentApproving: TDocumentApproving
      ); virtual;
      
    public

      constructor Create(
        EmployeeRepository: IEmployeeRepository;
        DocumentViewingAccountingService: IDocumentViewingAccountingService;
        DocumentFlowEmployeeInfoDTOMapper: TDocumentFlowEmployeeInfoDTOMapper
      );

      function MapDocumentApprovingsInfoDTOFrom(
        Document: TDocument;
        AccessingEmployee: TEmployee
      ): TDocumentApprovingsInfoDTO; overload; virtual;

      function MapDocumentApprovingsInfoDTOFrom(
        DocumentApprovings: TDocumentApprovings
      ): TDocumentApprovingsInfoDTO; overload; virtual;

  end;



implementation

uses

  IDomainObjectBaseUnit,
  Variants, DocumentApprovingPerformingRule;

{ TDocumentApprovingsInfoDTOMapper }

constructor TDocumentApprovingsInfoDTOMapper.Create(
  EmployeeRepository: IEmployeeRepository;
  DocumentViewingAccountingService: IDocumentViewingAccountingService;
  DocumentFlowEmployeeInfoDTOMapper: TDocumentFlowEmployeeInfoDTOMapper
);
begin

  inherited Create;

  FEmployeeRepository := EmployeeRepository;
  FDocumentViewingAccountingService := DocumentViewingAccountingService;
  FDocumentFlowEmployeeInfoDTOMapper := DocumentFlowEmployeeInfoDTOMapper;
  FFreeDocumentFlowEmployeeInfoDTOMapper := FDocumentFlowEmployeeInfoDTOMapper;
  
end;

function TDocumentApprovingsInfoDTOMapper.MapDocumentApprovingsInfoDTOFrom(
  Document: TDocument;
  AccessingEmployee: TEmployee
): TDocumentApprovingsInfoDTO;
var
    DocumentApproving: TDocumentApproving;
begin

  Result := TDocumentApprovingsInfoDTO.Create;

  if not Assigned(Document.Approvings) then Exit;
  
  try

    for DocumentApproving in Document.Approvings do begin

      Result.Add(
        MapDocumentApprovingInfoDTO(
          Document, DocumentApproving, AccessingEmployee)
        );

    end;

  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;

    end;

  end;

end;

function TDocumentApprovingsInfoDTOMapper.MapDocumentApprovingInfoDTO(
  Document: TDocument;
  DocumentApproving: TDocumentApproving;
  AccessingEmployee: TEmployee
): TDocumentApprovingInfoDTO;
var
    ReplaceableApproving: TDocumentApproving;
    FreeReplaceableApproving: IDomainObjectBase;
begin

  Result := TDocumentApprovingInfoDTO.Create;

  try

    FillDocumentApprovingInfoDTOFrom(Result, DocumentApproving);
    
    ReplaceableApproving :=
      Document
        .WorkingRules
          .ApprovingPerformingRule
            .FindReplaceableDocumentApprovingFor(Document, AccessingEmployee);

    FreeReplaceableApproving := ReplaceableApproving;

    Result.IsAccessible := DocumentApproving.IsSameAs(ReplaceableApproving);

  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;

    end;

  end;

end;

function TDocumentApprovingsInfoDTOMapper.
  MapDocumentApprovingsInfoDTOFrom(
    DocumentApprovings: TDocumentApprovings
  ): TDocumentApprovingsInfoDTO;
var
    DocumentApproving: TDocumentApproving;
    DocumentApprovingInfoDTO: TDocumentApprovingInfoDTO;
begin

  Result := TDocumentApprovingsInfoDTO.Create;

  if not Assigned(DocumentApprovings) then Exit;
  
  try

    for DocumentApproving in DocumentApprovings do begin

      DocumentApprovingInfoDTO := TDocumentApprovingInfoDTO.Create;

      Result.Add(DocumentApprovingInfoDTO);

      FillDocumentApprovingInfoDTOFrom(DocumentApprovingInfoDTO, DocumentApproving);

    end;

  except

    FreeAndNil(Result);

    Raise;
    
  end;

end;

procedure TDocumentApprovingsInfoDTOMapper.FillDocumentApprovingInfoDTOFrom(
  DocumentApprovingInfoDTO: TDocumentApprovingInfoDTO;
  DocumentApproving: TDocumentApproving
);
var
    ActualApprover: TEmployee;
    Free: IDomainObjectBase;
begin

  DocumentApprovingInfoDTO.Id := DocumentApproving.Identity;
  DocumentApprovingInfoDTO.PerformingDateTime := DocumentApproving.PerformingDateTime;
  DocumentApprovingInfoDTO.PerformingResultName := DocumentApproving.PerformingResultName;

  DocumentApprovingInfoDTO.IsViewedByApprover :=
    FDocumentViewingAccountingService.IsDocumentViewedByEmployee(
      DocumentApproving.DocumentId, DocumentApproving.Approver.Identity
    );

    DocumentApprovingInfoDTO.Note := DocumentApproving.Note;

    DocumentApprovingInfoDTO.ApproverInfoDTO :=
      FDocumentFlowEmployeeInfoDTOMapper
        .MapDocumentFlowEmployeeInfoDTOFrom(DocumentApproving.Approver);

  if not VarIsNull(DocumentApproving.ActuallyPerformedEmployeeId) then begin

    ActualApprover :=
      FEmployeeRepository
        .FindEmployeeById(DocumentApproving.ActuallyPerformedEmployeeId);

    if Assigned(ActualApprover) then begin

      Free := ActualApprover;

      DocumentApprovingInfoDTO.ActuallyPerformedEmployeeInfoDTO :=
        FDocumentFlowEmployeeInfoDTOMapper.MapDocumentFlowEmployeeInfoDTOFrom(
          ActualApprover
        );

    end;

  end;

end;


end.
