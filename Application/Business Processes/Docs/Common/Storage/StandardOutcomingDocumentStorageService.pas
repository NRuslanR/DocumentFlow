unit StandardOutcomingDocumentStorageService;

interface

uses

  Document,
  DocumentUsageEmployeeAccessRightsInfoDTO,
  Employee,
  StandardDocumentStorageService,
  Session,
  DocumentDirectory,
  IDocumentUnit,
  IEmployeeRepositoryUnit,
  DocumentInfoReadService,
  DocumentUsageEmployeeAccessRightsService,
  DocumentObjectsDTODomainMapper,
  DocumentCreatingService,
  DocumentFullInfoDTOMapper,
  DocumentUsageEmployeeAccessRightsInfoDTOMapper,
  DocumentResponsibleInfoDTOMapper,
  SysUtils,
  Classes;

type

  TStandardOutcomingDocumentStorageService =
    class (TStandardDocumentStorageService)

      protected

        function EnsureThatEmployeeHasDocumentUsageAccessRights(
          Document: IDocument;
          RequestingEmployee: TEmployee
        ): IDocumentUsageEmployeeAccessRightsInfoDTO; override;

      public

        constructor Create(
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

        ); override;

    end;

implementation

{ TStandardOutcomingDocumentStorageService }

constructor TStandardOutcomingDocumentStorageService.Create(
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
    DocumentCreatingService,
    DocumentInfoReadService,
    DocumentUsageEmployeeAccessRightsService,
    DocumentObjectsDTODomainMapper,
    DocumentFullInfoDTOMapper,
    DocumentUsageEmployeeAccessRightsInfoDTOMapper,
    DocumentResponsibleInfoDTOMapper
  );

end;

function TStandardOutcomingDocumentStorageService.EnsureThatEmployeeHasDocumentUsageAccessRights(
  Document: IDocument;
  RequestingEmployee: TEmployee
): IDocumentUsageEmployeeAccessRightsInfoDTO;
begin

  Result :=
    inherited EnsureThatEmployeeHasDocumentUsageAccessRights(
      Document, RequestingEmployee
    );

  with Result.AsSelf.DocumentChargeSheetsAccessRightsInfoDTO do begin

    if not AnyChargeSheetsCanBeViewed then Exit;

    AnyChargeSheetsCanBeIssued := False;
    AnyChargeSheetsCanBeChanged := False;
    AnyChargeSheetsCanBeRemoved := False;
    AnyChargeSheetsCanBePerformed := False;


  end;
  
end;

end.
