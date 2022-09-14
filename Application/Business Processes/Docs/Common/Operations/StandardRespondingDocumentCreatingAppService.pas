unit StandardRespondingDocumentCreatingAppService;

interface

uses

  EmployeeDocumentOperationService,
  RespondingDocumentCreatingAppService,
  RespondingDocumentCreatingService,
  DocumentDirectory,
  IEmployeeRepositoryUnit,
  DocumentFullInfoDTOMapper,
  Document,
  IDocumentUnit,
  DocumentUsageEmployeeAccessRightsInfoDTOMapper,
  Employee,
  Session,
  SysUtils,
  Classes;

type

  TStandardRespondingDocumentCreatingAppService =
    class (TEmployeeDocumentOperationService, IRespondingDocumentCreatingAppService)

      protected

        FRespondingDocumentCreatingService: IRespondingDocumentCreatingService;
        FDocumentFullInfoDTOMapper: TDocumentFullInfoDTOMapper;
        FDocumentUsageEmployeeAccessRightsInfoDTOMapper: TDocumentUsageEmployeeAccessRightsInfoDTOMapper;
        
        procedure RaiseExceptionIfRequestingEmployeeNotFound(
          RequestingEmployee: TEmployee
        );

        procedure RaiseExceptionIfSourceDocumentNotFound(
          SourceDocument: IDocument
        );

        function MapRespondingDocumentCreatingResultDtoFrom(
          RespondingDocumentCreatingResult: TRespondingDocumentCreatingResult;
          RequestingEmployee: TEmployee
          
        ): TRespondingDocumentCreatingResultDto;

      public

        constructor Create(
          Session: ISession;
          DocumentDirectory: IDocumentDirectory;
          EmployeeRepository: IEmployeeRepository;
          RespondingDocumentCreatingService: IRespondingDocumentCreatingService;
          DocumentFullInfoDTOMapper: TDocumentFullInfoDTOMapper;
          DocumentUsageEmployeeAccessRightsInfoDTOMapper: TDocumentUsageEmployeeAccessRightsInfoDTOMapper
        );
        
        function CreateRespondingDocumentFor(
          const DocumentId, EmployeeId: Variant
        ): TRespondingDocumentCreatingResultDto;
      
    end;

implementation

uses

  IDomainObjectBaseUnit, BusinessProcessService, DocumentOperationService;
  
{ TStandardRespondingDocumentCreatingAppService }

constructor TStandardRespondingDocumentCreatingAppService.Create(
  Session: ISession;
  DocumentDirectory: IDocumentDirectory;
  EmployeeRepository: IEmployeeRepository;
  RespondingDocumentCreatingService: IRespondingDocumentCreatingService;
  DocumentFullInfoDTOMapper: TDocumentFullInfoDTOMapper;
  DocumentUsageEmployeeAccessRightsInfoDTOMapper: TDocumentUsageEmployeeAccessRightsInfoDTOMapper
);
begin

  inherited Create(
    Session,
    DocumentDirectory,
    EmployeeRepository
  );

  FRespondingDocumentCreatingService := RespondingDocumentCreatingService;
  FDocumentFullInfoDTOMapper := DocumentFullInfoDTOMapper;
  
end;

function TStandardRespondingDocumentCreatingAppService.CreateRespondingDocumentFor(
  const DocumentId, EmployeeId: Variant
): TRespondingDocumentCreatingResultDto;
var
    SourceDocument: IDocument;

    RequestingEmployee: TEmployee;
    FreeRequestingEmployee: IDomainObjectBase;

    RespondingDocumentCreatingResult: TRespondingDocumentCreatingResult;
    FreeRespondingDocumentCreatingResult: IDomainObjectBase;
begin

  FSession.Start;

  try

    RequestingEmployee := GetEmployee(EmployeeId);

    RaiseExceptionIfRequestingEmployeeNotFound(RequestingEmployee);

    FreeRequestingEmployee := RequestingEmployee;

    SourceDocument := GetDocument(DocumentId);

    RaiseExceptionIfSourceDocumentNotFound(SourceDocument);

    RespondingDocumentCreatingResult :=
      FRespondingDocumentCreatingService.CreateRespondingDocumentFor(
        SourceDocument, RequestingEmployee
      );

    FSession.Commit;
    
    FreeRespondingDocumentCreatingResult := RespondingDocumentCreatingResult;

    Result :=
      MapRespondingDocumentCreatingResultDtoFrom(
        RespondingDocumentCreatingResult,
        RequestingEmployee
      );

  except

    on E: Exception do begin

      FSession.Rollback;

      RaiseFailedBusinessProcessServiceException(E.Message);
      
    end;

  end;

end;

function TStandardRespondingDocumentCreatingAppService.
  MapRespondingDocumentCreatingResultDtoFrom(
    RespondingDocumentCreatingResult: TRespondingDocumentCreatingResult;
    RequestingEmployee: TEmployee

  ): TRespondingDocumentCreatingResultDto;
begin

  Result := TRespondingDocumentCreatingResultDto.Create;

  try

    Result.DocumentFullInfoDTO :=
      FDocumentFullInfoDTOMapper.MapDocumentFullInfoDTOFrom(
        TDocument(RespondingDocumentCreatingResult.RespondingDocument.Self),
        RequestingEmployee,
        RespondingDocumentCreatingResult.RespondingDocumentRelations
      );

    Result.DocumentUsageEmployeeAccessRightsInfoDTO :=
      FDocumentUsageEmployeeAccessRightsInfoDTOMapper
        .MapDocumentUsageEmployeeAccessRightsInfoDTOFrom(
          RespondingDocumentCreatingResult.RespondingDocumentAccessRights
        );
        
  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;
  
end;

procedure TStandardRespondingDocumentCreatingAppService.
  RaiseExceptionIfRequestingEmployeeNotFound(
    RequestingEmployee: TEmployee
  );
begin

  if not Assigned(RequestingEmployee) then begin

    RaiseFailedBusinessProcessServiceException(
      'Не найдена информация о сотруднике'
    );
    
  end;

end;

procedure TStandardRespondingDocumentCreatingAppService.
  RaiseExceptionIfSourceDocumentNotFound(
    SourceDocument: IDocument
  );
begin

  if not Assigned(SourceDocument) then begin

    RaiseFailedBusinessProcessServiceException(
      'Не найден исходный документ, на основании ' +
      'которого необходимо сделать ответный документ'
    );

  end;

end;

end.
