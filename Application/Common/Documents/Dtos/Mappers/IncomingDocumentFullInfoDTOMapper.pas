unit IncomingDocumentFullInfoDTOMapper;

interface

uses

  DocumentRepositoryRegistry,
  DocumentDTOMapper,
  DocumentApprovingsInfoDTOMapper,
  DocumentFlowEmployeeInfoDTOMapper,
  IncomingDocumentFullInfoDTO,
  DocumentFullInfoDTO,
  IncomingDocumentDTOMapper,
  DocumentFullInfoDTOMapper,
  DocumentChargeSheetsInfoDTODomainMapper,
  SysUtils,
  Classes;

type

  TIncomingDocumentFullInfoDTOMapper = class (TDocumentFullInfoDTOMapper)

    protected

      function CreateDocumentFullInfoDTOInstance: TDocumentFullInfoDTO; override;

    public

      constructor Create(
        DocumentRepositoryRegistry: IDocumentRepositoryRegistry;
        DocumentDTOMapper: TDocumentDTOMapper;
        DocumentApprovingsInfoDTOMapper: TDocumentApprovingsInfoDTOMapper;
        DocumentChargeSheetsInfoDTOMapper: IDocumentChargeSheetsInfoDTODomainMapper;
        DocumentFlowEmployeeInfoDTOMapper: TDocumentFlowEmployeeInfoDTOMapper
      ); overload; override;

      constructor Create(
        DocumentRepositoryRegistry: IDocumentRepositoryRegistry;
        DocumentDTOMapper: TIncomingDocumentDTOMapper;
        DocumentApprovingsInfoDTOMapper: TDocumentApprovingsInfoDTOMapper;
        DocumentChargeSheetsInfoDTODomainMapper: TDocumentChargeSheetsInfoDTODomainMapper;
        DocumentFlowEmployeeInfoDTOMapper: TDocumentFlowEmployeeInfoDTOMapper
      ); overload;

  end;


implementation

{ TIncomingDocumentFullInfoDTOMapper }

constructor TIncomingDocumentFullInfoDTOMapper.Create(
  DocumentRepositoryRegistry: IDocumentRepositoryRegistry;
  DocumentDTOMapper: TDocumentDTOMapper;
  DocumentApprovingsInfoDTOMapper: TDocumentApprovingsInfoDTOMapper;
  DocumentChargeSheetsInfoDTOMapper: IDocumentChargeSheetsInfoDTODomainMapper;
  DocumentFlowEmployeeInfoDTOMapper: TDocumentFlowEmployeeInfoDTOMapper
);
begin

  if not (DocumentDTOMapper is TIncomingDocumentDTOMapper) then begin

    raise Exception.Create(
      'Программная ошибка. DocumentDTOMapper ' +
      'не является производным от IncomingDocumentDTOMapper'
    );
    
  end;

  inherited Create(
    DocumentRepositoryRegistry,
    DocumentDTOMapper,
    DocumentApprovingsInfoDTOMapper,
    DocumentChargeSheetsInfoDTOMapper,
    DocumentFlowEmployeeInfoDTOMapper
  );

end;

constructor TIncomingDocumentFullInfoDTOMapper.Create(
  DocumentRepositoryRegistry: IDocumentRepositoryRegistry;
  DocumentDTOMapper: TIncomingDocumentDTOMapper;
  DocumentApprovingsInfoDTOMapper: TDocumentApprovingsInfoDTOMapper;
  DocumentChargeSheetsInfoDTODomainMapper: TDocumentChargeSheetsInfoDTODomainMapper;
  DocumentFlowEmployeeInfoDTOMapper: TDocumentFlowEmployeeInfoDTOMapper
);
begin

  Create(
    DocumentRepositoryRegistry,
    TDocumentDTOMapper(DocumentDTOMapper),
    DocumentApprovingsInfoDTOMapper,
    DocumentChargeSheetsInfoDTODomainMapper,
    DocumentFlowEmployeeInfoDTOMapper
  );
  
end;

function TIncomingDocumentFullInfoDTOMapper.CreateDocumentFullInfoDTOInstance: TDocumentFullInfoDTO;
begin

  Result := TIncomingDocumentFullInfoDTO.Create;
  
end;

end.
