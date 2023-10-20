unit IncomingDocumentCardFormViewModelMapper;

interface

uses

  DocumentFullInfoDTO,
  DocumentChargeSetHolder,
  DocumentRelationSetHolder,
  DocumentApprovingCycleSetHolder,
  DocumentCardFormViewModel,
  ChangedDocumentInfoDTO,
  NewDocumentInfoDTO,
  EmployeeDocumentCardFormViewModelMapper,
  DocumentMainInformationFormViewModelMapper,
  IncomingDocumentCardFormViewModel,
  IncomingDocumentMainInformationFormViewModel,
  DocumentCardFormViewModelMapper,
  DocumentChargesFormViewModelMapper,
  DocumentChargeSheetsFormViewModelMapper,
  DocumentRelationsFormViewModelMapper,
  DocumentFilesFormViewModelMapper,
  DocumentApprovingsFormViewModelMapper,
  DocumentDataSetHoldersFactory,
  IncomingDocumentMainInformationFormViewModelMapper,
  DocumentUsageEmployeeAccessRightsInfoDTO,
  DocumentFilesViewFormViewModelMapper,
  SysUtils,
  Classes;

type

  TIncomingDocumentCardFormViewModelMapper = class (TEmployeeDocumentCardFormViewModelMapper)

    private
    
    protected

      function CreateChangedDocumentInfoDTOInstance:
        TChangedDocumentInfoDTO; override;

      function CreateNewDocumentInfoDTOInstance:
        TNewDocumentInfoDTO; override;

    public

      constructor Create; overload;

      constructor Create(
        IncomingDocumentMainInformationFormViewModelMapper: TIncomingDocumentMainInformationFormViewModelMapper;
        ChargesFormViewModelMapper: TDocumentChargesFormViewModelMapper;
        ChargeSheetsFormViewModelMapper: TDocumentChargeSheetsFormViewModelMapper;
        RelationsFormViewModelMapper: TDocumentRelationsFormViewModelMapper;
        FilesFormViewModelMapper: TDocumentFilesFormViewModelMapper;
        ApprovingsFormViewModelMapper: TDocumentApprovingsFormViewModelMapper;
        FilesViewFormViewModelMapper: TDocumentFilesViewFormViewModelMapper
      ); overload;

      function MapDocumentCardFormViewModelFrom(

        DocumentFullInfoDTO: TDocumentFullInfoDTO;
        DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO

      ): TDocumentCardFormViewModel; override;

      function MapDocumentCardFormViewModelToChangedDocumentInfoDTO(
        DocumentCardViewModel: TDocumentCardFormViewModel
      ): TChangedDocumentInfoDTO; override;

      function MapDocumentCardFormViewModelToNewDocumentInfoDTO(
        DocumentCardViewModel: TDocumentCardFormViewModel
      ): TNewDocumentInfoDTO; override;

  end;

implementation

{ TIncomingDocumentCardFormViewModelMapper }

constructor TIncomingDocumentCardFormViewModelMapper.Create;
begin

  inherited;
  
end;

constructor TIncomingDocumentCardFormViewModelMapper.Create(
  IncomingDocumentMainInformationFormViewModelMapper: TIncomingDocumentMainInformationFormViewModelMapper;
  ChargesFormViewModelMapper: TDocumentChargesFormViewModelMapper;
  ChargeSheetsFormViewModelMapper: TDocumentChargeSheetsFormViewModelMapper;
  RelationsFormViewModelMapper: TDocumentRelationsFormViewModelMapper;
  FilesFormViewModelMapper: TDocumentFilesFormViewModelMapper;
  ApprovingsFormViewModelMapper: TDocumentApprovingsFormViewModelMapper;
  FilesViewFormViewModelMapper: TDocumentFilesViewFormViewModelMapper
);
begin

  inherited Create(
    IncomingDocumentMainInformationFormViewModelMapper,
    ChargesFormViewModelMapper,
    ChargeSheetsFormViewModelMapper,
    RelationsFormViewModelMapper,
    FilesFormViewModelMapper,
    ApprovingsFormViewModelMapper,
    FilesViewFormViewModelMapper
  );
  
end;

function TIncomingDocumentCardFormViewModelMapper.CreateChangedDocumentInfoDTOInstance: TChangedDocumentInfoDTO;
begin

  raise Exception.Create(
          '��� �������� ���������� ' +
          '����������� ����� ����������� ' +
          '�� �������������� ������� DTO, ' +
          '��� ��� �� �������� �������� ' +
          '��������� �� ��������'
        );
        
end;

function TIncomingDocumentCardFormViewModelMapper.CreateNewDocumentInfoDTOInstance: TNewDocumentInfoDTO;
begin

  raise Exception.Create(
          '��� �������� ���������� ' +
          '�� ��������� ����� ����������� ' +
          '�� �������������� ������� DTO, ' +
          '��� ��� �������� �������� �� ' +
          '����� ����������� �������'
        );

end;

function TIncomingDocumentCardFormViewModelMapper.MapDocumentCardFormViewModelFrom(

  DocumentFullInfoDTO: TDocumentFullInfoDTO;
  DocumentUsageEmployeeAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO

): TDocumentCardFormViewModel;
begin

  Result :=
    inherited MapDocumentCardFormViewModelFrom(
      DocumentFullInfoDTO,
      DocumentUsageEmployeeAccessRightsInfoDTO
    );
    
end;

function TIncomingDocumentCardFormViewModelMapper.
  MapDocumentCardFormViewModelToChangedDocumentInfoDTO(
    DocumentCardViewModel: TDocumentCardFormViewModel
  ): TChangedDocumentInfoDTO;
begin

  raise Exception.Create(
          '��� �������� ���������� ' +
          '�� ��������� ����� ����������� ' +
          '�� ������� DTO ��� ���������� ����������'
        );
        
end;

function TIncomingDocumentCardFormViewModelMapper.
  MapDocumentCardFormViewModelToNewDocumentInfoDTO(
    DocumentCardViewModel: TDocumentCardFormViewModel
  ): TNewDocumentInfoDTO;
begin

  raise Exception.Create(
          '��� �������� ���������� ' +
          '�� ��������� ����� ����������� ' +
          '�� ������� DTO ��� ����������� ����������'
        );

end;

end.

