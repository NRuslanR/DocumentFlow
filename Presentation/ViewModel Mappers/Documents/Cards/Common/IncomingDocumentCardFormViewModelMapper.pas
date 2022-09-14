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
  IncomingDocumentMainInformationFormViewModelMapper,
  IncomingDocumentMainInformationFormViewModel,
  DocumentCardFormViewModelMapper,
  DocumentChargesFormViewModelMapper,
  DocumentRelationsFormViewModelMapper,
  DocumentFilesFormViewModelMapper,
  DocumentApprovingsFormViewModelMapper,
  DocumentDataSetHoldersFactory,
  DocumentUsageEmployeeAccessRightsInfoDTO,
  SysUtils,
  Classes;

type

  TIncomingDocumentCardFormViewModelMapper = class (TEmployeeDocumentCardFormViewModelMapper)

    protected

      FDocumentCardFormViewModelMapper: TDocumentCardFormViewModelMapper;
      
    protected

      function CreateMainInformationFormViewModelMapper:
        TDocumentMainInformationFormViewModelMapper; override;

    protected

      function CreateDocumentCardFormViewModelInstance:
        TDocumentCardFormViewModel; override;

      function CreateChangedDocumentInfoDTOInstance:
        TChangedDocumentInfoDTO; override;

      function CreateNewDocumentInfoDTOInstance:
        TNewDocumentInfoDTO; override;

    public

      destructor Destroy; override;
      constructor Create(
        DocumentDataSetHoldersFactory: IDocumentDataSetHoldersFactory;
        DocumentCardFormViewModelMapper: TDocumentCardFormViewModelMapper
      );

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

constructor TIncomingDocumentCardFormViewModelMapper.Create(
  DocumentDataSetHoldersFactory: IDocumentDataSetHoldersFactory;
  DocumentCardFormViewModelMapper: TDocumentCardFormViewModelMapper
);
begin

  FDocumentCardFormViewModelMapper := DocumentCardFormViewModelMapper;
  
  inherited Create(DocumentDataSetHoldersFactory);
  
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


function TIncomingDocumentCardFormViewModelMapper.CreateDocumentCardFormViewModelInstance: TDocumentCardFormViewModel;
begin

  Result := TIncomingDocumentCardFormViewModel.Create;
  
end;

function TIncomingDocumentCardFormViewModelMapper.
  CreateMainInformationFormViewModelMapper: TDocumentMainInformationFormViewModelMapper;
begin

  Result :=
    TIncomingDocumentMainInformationFormViewModelMapper.Create(
      FDocumentCardFormViewModelMapper.MainInformationFormViewModelMapper
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

destructor TIncomingDocumentCardFormViewModelMapper.Destroy;
begin

  if Assigned(FMainInformationFormViewModelMapper) then begin

    with FMainInformationFormViewModelMapper as
         TIncomingDocumentMainInformationFormViewModelMapper
    do begin

      OriginalDocumentMainInformationFormViewModelMapper := nil;

    end;

  end;

  FreeAndNil(FDocumentCardFormViewModelMapper);

  inherited;

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

