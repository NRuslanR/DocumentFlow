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

    protected

      FDocumentCardFrameFactory: TDocumentCardFrameFactory;

    public

      destructor Destroy; override;

      constructor Create(
        DocumentCardFrameFactory: TDocumentCardFrameFactory;
        Options: IDocumentCardFrameFactoryOptions = nil
      );

      function CreateDocumentCardFrameFrom(
        const ViewModel: TDocumentCardFormViewModel;
        DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO = nil
      ): TDocumentCardFrame; override;

      function CreateCardFrameForNewDocumentCreating(
        const ViewModel: TDocumentCardFormViewModel;
        EmployeeDocumentKindAccessRightsInfoDto: TEmployeeDocumentKindAccessRightsInfoDto
      ): TDocumentCardFrame; overload; override;

      function CreateCardFrameForNewDocumentCreating(
        const ViewModel: TDocumentCardFormViewModel;
        DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
      ): TDocumentCardFrame; overload; override;

      function CreateEmptyNoActivedDocumentCardFrame(
      ): TDocumentCardFrame; override;

      function CreateDocumentCardFrameForView(
        const ViewModel: TDocumentCardFormViewModel
      ): TDocumentCardFrame; override;

  end;

implementation

{ TIncomingDocumentCardFrameFactory }

destructor TIncomingDocumentCardFrameFactory.Destroy;
begin

  FreeAndNil(FDocumentCardFrameFactory);

  inherited Destroy;

end;

function TIncomingDocumentCardFrameFactory.
  CreateCardFrameForNewDocumentCreating(
    const ViewModel: TDocumentCardFormViewModel;
    EmployeeDocumentKindAccessRightsInfoDto: TEmployeeDocumentKindAccessRightsInfoDto
  ): TDocumentCardFrame;
begin

  Raise Exception.Create(
          'Карточка не может ' +
          'использоваться для создания ' +
          'входящих документов'
        );
        
end;

constructor TIncomingDocumentCardFrameFactory.Create(
  DocumentCardFrameFactory: TDocumentCardFrameFactory;
  Options: IDocumentCardFrameFactoryOptions);
begin

  inherited Create(Options);

  FDocumentCardFrameFactory := DocumentCardFrameFactory;
  
end;

function TIncomingDocumentCardFrameFactory.CreateCardFrameForNewDocumentCreating(
  const ViewModel: TDocumentCardFormViewModel;
  DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
): TDocumentCardFrame;
begin

  Raise Exception.Create(
          'Карточка не может ' +
          'использоваться для создания ' +
          'входящих документов'
        );

end;

function TIncomingDocumentCardFrameFactory.
CreateDocumentCardFrameForView(
  const ViewModel: TDocumentCardFormViewModel
): TDocumentCardFrame;
begin

  Result :=
    FDocumentCardFrameFactory.CreateDocumentCardFrameForView(ViewModel);
    
end;

function TIncomingDocumentCardFrameFactory.CreateDocumentCardFrameFrom(
  const ViewModel: TDocumentCardFormViewModel;
  DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
): TDocumentCardFrame;
begin

  Result :=
    FDocumentCardFrameFactory
      .CreateDocumentCardFrameFrom(
        ViewModel, DocumentUsageEmployeeAccessRightsInfoDTO
      );
  
end;

function TIncomingDocumentCardFrameFactory
  .CreateEmptyNoActivedDocumentCardFrame: TDocumentCardFrame;
begin

  Result :=
    FDocumentCardFrameFactory.CreateEmptyNoActivedDocumentCardFrame;

end;

end.
