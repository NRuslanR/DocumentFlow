unit PersonnelOrderDTOMapper;

interface

uses

  PersonnelOrderSubKindSetReadService,
  PersonnelOrderFullInfoDTO,
  DocumentDTOMapper,
  Document,
  DocumentApprovings,
  DocumentCharges,
  DocumentSignings,
  DocumentFullInfoDTO,
  DocumentChargeSheetsInfoDTO,
  DocumentKindRepository,
  DocumentNumeratorRegistry,
  DocumentApprovingsInfoDTOMapper,
  DocumentChargesInfoDTODomainMapper,
  DocumentResponsibleInfoDTO,
  DocumentResponsibleInfoDTOMapper,
  DepartmentInfoDTO,
  DocumentFlowEmployeeInfoDTOMapper,
  IDocumentResponsibleRepositoryUnit,
  IEmployeeRepositoryUnit,
  DocumentChargeInterface,
  Disposable,
  DocumentKind,
  PersonnelOrder,
  PersonnelOrderSubKind,
  PersonnelOrderSubKindFinder,
  Employee,
  SysUtils,
  Classes;

type

  TPersonnelOrderDTOMapper = class (TDocumentDTOMapper)

    private

      FSubKindFinder: IPersonnelOrderSubKindFinder;

    protected

      function CreateDocumentDTOInstance: TDocumentDTO; override;

    public

      constructor Create(
        SubKindFinder: IPersonnelOrderSubKindFinder;
        EmployeeRepository: IEmployeeRepository;
        DocumentKindRepository: IDocumentKindRepository;
        DocumentResponsibleInfoDTOMapper: IDocumentResponsibleInfoDTOMapper;
        DocumentNumeratorRegistry: IDocumentNumeratorRegistry;
        DocumentChargesInfoDTODomainMapper: IDocumentChargesInfoDTODomainMapper;
        DocumentApprovingsInfoDTOMapper: TDocumentApprovingsInfoDTOMapper;
        DocumentFlowEmployeeInfoDTOMapper: TDocumentFlowEmployeeInfoDTOMapper
      );

      function MapDocumentDTOFrom(
        Document: TDocument;
        AccessingEmployee: TEmployee
      ): TDocumentDTO; override;

  end;
  
implementation

uses

  VariantFunctions,
  IDomainObjectBaseUnit;
  
{ TPersonnelOrderDTOMapper }

constructor TPersonnelOrderDTOMapper.Create(
  SubKindFinder: IPersonnelOrderSubKindFinder;
  EmployeeRepository: IEmployeeRepository;
  DocumentKindRepository: IDocumentKindRepository;
  DocumentResponsibleInfoDTOMapper: IDocumentResponsibleInfoDTOMapper;
  DocumentNumeratorRegistry: IDocumentNumeratorRegistry;
  DocumentChargesInfoDTODomainMapper: IDocumentChargesInfoDTODomainMapper;
  DocumentApprovingsInfoDTOMapper: TDocumentApprovingsInfoDTOMapper;
  DocumentFlowEmployeeInfoDTOMapper: TDocumentFlowEmployeeInfoDTOMapper
);
begin

  inherited Create(
    EmployeeRepository,
    DocumentKindRepository,
    DocumentResponsibleInfoDTOMapper,
    DocumentNumeratorRegistry,
    DocumentChargesInfoDTODomainMapper,
    DocumentApprovingsInfoDTOMapper,
    DocumentFlowEmployeeInfoDTOMapper
  );

  FSubKindFinder := SubKindFinder;
  
end;

function TPersonnelOrderDTOMapper.CreateDocumentDTOInstance: TDocumentDTO;
begin

  Result := TPersonnelOrderDTO.Create;

end;

function TPersonnelOrderDTOMapper.MapDocumentDTOFrom(Document: TDocument;
  AccessingEmployee: TEmployee): TDocumentDTO;
var
    PersonnelOrder: TPersonnelOrder;
    
    SubKind: TPersonnelOrderSubKind;
    FreeSubKind: IDomainObjectBase;
begin

  Result := inherited MapDocumentDTOFrom(Document, AccessingEmployee);

  PersonnelOrder := TPersonnelOrder(Document);

  if VarIsNullOrEmpty(PersonnelOrder.SubKindId) then Exit;
  
  SubKind := FSubKindFinder.FindPersonnelOrderSubKindById(PersonnelOrder.SubKindId);

  FreeSubKind := SubKind;
  
  with TPersonnelOrderDTO(Result) do begin

    SubKindId := SubKind.Identity;
    SubKindName := SubKind.Name;

  end;

end;

end.
