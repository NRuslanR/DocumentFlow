unit PersonnelOrderCardFrameFactory;

interface

uses

  DocumentCardFrameFactory,
  unDocumentCardFrame,
  DocumentUsageEmployeeAccessRightsInfoDTO,
  unPersonnelOrderCardFrame,
  unPersonnelOrderApprovingsFrame,
  unPersonnelOrderMainInformationFrame,
  unPersonnelOrderChargesFrame,
  unPersonnelOrderChargeSheetsFrame,
  DocumentMainInformationFrameUnit,
  EmployeeDocumentKindAccessRightsInfoDto,
  DocumentChargesFormViewModelUnit,
  DocumentChargeSheetsFormViewModel,
  unDocumentChargesFrame,
  unDocumentChargeSheetsFrame,
  DocumentMainInformationFormViewModelUnit,
  DocumentApprovingsFrameUnit,
  DocumentCardFormViewModel,
  SysUtils;

type

  TPersonnelOrderCardFrameFactory = class (TDocumentCardFrameFactory)

    protected

      function CreateDocumentCardFrameInstanceForNewDocumentCreating(
        EmployeeDocumentKindAccessRightsInfoDto: TEmployeeDocumentKindAccessRightsInfoDto
      ): TDocumentCardFrame; overload; override;

      function CreateDocumentCardFrameInstanceForNewDocumentCreating(
        DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
      ): TDocumentCardFrame; overload; override;

      function CreateDefaultDocumentCardFrameInstance(
        DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO = nil
      ): TDocumentCardFrame; override;

      function CreatePersonnelOrderCardFrameInstance: TPersonnelOrderCardFrame;

    protected

      function CreateDocumentMainInformationFrameInstance: TDocumentMainInformationFrame; override;
      function CreateDocumentApprovingsFrameInstance: TDocumentApprovingsFrame; override;
      function CreateDocumentChargesFrameInstance: TDocumentChargesFrame; override;
      function CreateDocumentChargeSheetsFrameInstance: TDocumentChargeSheetsFrame; override;

    public

      function CreateDocumentCardFrameFrom(
        const ViewModel: TDocumentCardFormViewModel;
        DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO = nil
      ): TDocumentCardFrame; override;

  end;

implementation


{ TPersonnelOrderCardFrameFactory }

function TPersonnelOrderCardFrameFactory.CreateDefaultDocumentCardFrameInstance(
  DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO): TDocumentCardFrame;
begin

  Result := CreatePersonnelOrderCardFrameInstance;

end;

function TPersonnelOrderCardFrameFactory.CreateDocumentApprovingsFrameInstance: TDocumentApprovingsFrame;
begin

  Result := TPersonnelOrderApprovingsFrame.Create(nil);
  
end;

function TPersonnelOrderCardFrameFactory.CreateDocumentCardFrameInstanceForNewDocumentCreating(
  EmployeeDocumentKindAccessRightsInfoDto: TEmployeeDocumentKindAccessRightsInfoDto
): TDocumentCardFrame;
begin

  Result := CreatePersonnelOrderCardFrameInstance;

end;

function TPersonnelOrderCardFrameFactory.CreateDocumentCardFrameFrom(
  const ViewModel: TDocumentCardFormViewModel;
  DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO
): TDocumentCardFrame;
begin

  Result := inherited CreateDocumentCardFrameFrom(ViewModel, DocumentUsageEmployeeAccessRightsInfoDTO);

end;

function TPersonnelOrderCardFrameFactory.CreateDocumentCardFrameInstanceForNewDocumentCreating(
  DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO): TDocumentCardFrame;
begin

  Result := CreatePersonnelOrderCardFrameInstance;

end;

function TPersonnelOrderCardFrameFactory.CreateDocumentChargesFrameInstance: TDocumentChargesFrame;
begin

  Result := TPersonnelOrderChargesFrame.Create(nil, False, False);

end;

function TPersonnelOrderCardFrameFactory.CreateDocumentChargeSheetsFrameInstance: TDocumentChargeSheetsFrame;
begin

  Result := TPersonnelOrderChargeSheetsFrame.Create(nil, False, False);
  
end;

function TPersonnelOrderCardFrameFactory.CreateDocumentMainInformationFrameInstance: TDocumentMainInformationFrame;
begin

  Result := TPersonnelOrderMainInformationFrame.Create(nil);
  
end;

function TPersonnelOrderCardFrameFactory.CreatePersonnelOrderCardFrameInstance: TPersonnelOrderCardFrame;
begin

  Result := TPersonnelOrderCardFrame.Create(nil, False, False);
  
end;

end.
