unit IncomingDocumentCardFrameFactory;

interface

uses

  DocumentCardFrameFactory,
  DocumentUsageEmployeeAccessRightsInfoDTO,
  DocumentCardFormViewModel,
  unDocumentCardFrame,
  unDocumentChargesFrame,
  DocumentRelationsFrameUnit,
  DocumentMainInformationFrameUnit,
  DocumentFilesFrameUnit,

  DocumentMainInformationFormViewModelUnit,
  DocumentChargesFormViewModelUnit,
  DocumentRelationsFormViewModelUnit,
  DocumentFilesViewFormViewModel,
  DocumentFilesFormViewModelUnit,

  DocumentRelationsReferenceFormUnit,
  DocumentFilesReferenceFormUnit,

  unDocumentChargeSheetsFrame,
  DocumentApprovingsFormViewModel,
  DocumentApprovingsFrameUnit,

  EmployeeDocumentKindAccessRightsInfoDto,
  
  SysUtils,
  Classes;

type

  TIncomingDocumentCardFrameFactory = class (TDocumentCardFrameFactory)

    public

      function CreateCardFrameForNewDocumentCreating(
        const ViewModel: TDocumentCardFormViewModel;
        EmployeeDocumentKindAccessRightsInfoDto: TEmployeeDocumentKindAccessRightsInfoDto
      ): TDocumentCardFrame; override;

  end;

implementation

{ TIncomingDocumentCardFrameFactory }

function TIncomingDocumentCardFrameFactory.
  CreateCardFrameForNewDocumentCreating(
    const ViewModel: TDocumentCardFormViewModel;
    EmployeeDocumentKindAccessRightsInfoDto: TEmployeeDocumentKindAccessRightsInfoDto
  ): TDocumentCardFrame;
begin

  raise Exception.Create(
          'Карточка не может ' +
          'использоваться для создания ' +
          'входящих документов'
        );
        
end;

end.
