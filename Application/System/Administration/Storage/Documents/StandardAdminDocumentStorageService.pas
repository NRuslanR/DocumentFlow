unit StandardAdminDocumentStorageService;

interface

uses

  StandardDocumentStorageService,
  DocumentUsageEmployeeAccessRightsInfoDTO,
  Employee,
  Document,
  VariantListUnit,
  DocumentFlowAuthorizationService,
  Session,
  DocumentDirectory,
  DocumentCreatingService,
  IEmployeeRepositoryUnit,
  DocumentInfoReadService,
  DocumentUsageEmployeeAccessRightsService,
  DocumentObjectsDTODomainMapper,
  AdminDocumentStorageService,
  DocumentFullInfoDTOMapper,
  DocumentUsageEmployeeAccessRightsInfoDTOMapper,
  DocumentResponsibleInfoDTOMapper,
  IDocumentUnit,
  SysUtils,
  Classes;

type

  TStandardAdminDocumentStorageService =
    class (TStandardDocumentStorageService, IAdminDocumentStorageService)

      protected

        FSystemAuthorizationService: IDocumentFlowAuthorizationService;

      protected

        function EnsureThatEmployeeHasDocumentUsageAccessRights(
          Document: IDocument;
          RequestingEmployee: TEmployee
        ): IDocumentUsageEmployeeAccessRightsInfoDTO; override;

        procedure EnsureEmployeeMayRemoveDocuments(
          RemovingEmployee: TEmployee;
          RemovableDocuments: TDocuments
        ); override;

      public

        constructor Create(

          SystemAuthorizationService: IDocumentFlowAuthorizationService;
          Session: ISession;
          DocumentDirectory: IDocumentDirectory;
          EmployeeRepository: IEmployeeRepository;
          DocumentCreatingService: IDocumentCreatingService;
          DocumentInfoReadService: IDocumentInfoReadService;
          DocumentUsageEmployeeAccessRightsService: IDocumentUsageEmployeeAccessRightsService;
          DocumentObjectsDTODomainMapper: TDocumentObjectsDTODomainMapper;
          DocumentFullInfoDTOMapper: TDocumentFullInfoDTOMapper;
          DocumentUsageEmployeeAccessRightsInfoDTOMapper: TDocumentUsageEmployeeAccessRightsInfoDTOMapper;
          DocumentResponsibleInfoDTOMapper: TDocumentResponsibleInfoDTOMapper

        );

    end;

implementation

{ TStandardAdminDocumentStorageService }

constructor TStandardAdminDocumentStorageService.Create(
  SystemAuthorizationService: IDocumentFlowAuthorizationService;
  Session: ISession;
  DocumentDirectory: IDocumentDirectory;
  EmployeeRepository: IEmployeeRepository;
  DocumentCreatingService: IDocumentCreatingService;
  DocumentInfoReadService: IDocumentInfoReadService;
  DocumentUsageEmployeeAccessRightsService: IDocumentUsageEmployeeAccessRightsService;
  DocumentObjectsDTODomainMapper: TDocumentObjectsDTODomainMapper;
  DocumentFullInfoDTOMapper: TDocumentFullInfoDTOMapper;
  DocumentUsageEmployeeAccessRightsInfoDTOMapper: TDocumentUsageEmployeeAccessRightsInfoDTOMapper;
  DocumentResponsibleInfoDTOMapper: TDocumentResponsibleInfoDTOMapper
);
begin

  inherited Create(
    Session,
    DocumentDirectory,
    EmployeeRepository,
    FDocumentCreatingService,
    DocumentInfoReadService,
    DocumentUsageEmployeeAccessRightsService,
    DocumentObjectsDTODomainMapper,
    DocumentFullInfoDTOMapper,
    DocumentUsageEmployeeAccessRightsInfoDTOMapper,
    DocumentResponsibleInfoDTOMapper
  );

  FSystemAuthorizationService := SystemAuthorizationService;

end;

procedure TStandardAdminDocumentStorageService.EnsureEmployeeMayRemoveDocuments(
  RemovingEmployee: TEmployee;
  RemovableDocuments: TDocuments
);
begin

  FSystemAuthorizationService.EnsureEmployeeIsAdminView(RemovingEmployee.Identity);

end;

function TStandardAdminDocumentStorageService.EnsureThatEmployeeHasDocumentUsageAccessRights(
  Document: IDocument;
  RequestingEmployee: TEmployee
): IDocumentUsageEmployeeAccessRightsInfoDTO;
begin

  FSystemAuthorizationService.EnsureEmployeeIsAdminView(RequestingEmployee.Identity);

  Result := TDocumentUsageEmployeeAccessRightsInfoDTO.Create;

  try

    with Result.AsSelf do begin

      DocumentCanBeViewed := True;
      DocumentCanBeRemoved := True;

    end;

  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;

end;

end.
