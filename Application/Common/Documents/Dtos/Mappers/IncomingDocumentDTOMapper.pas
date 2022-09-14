unit IncomingDocumentDTOMapper;

interface

uses

  Document,
  DocumentFullInfoDTO,
  DocumentDTOMapper,
  Employee,
  IncomingDocumentFullInfoDTO,
  IncomingDocument,
  DocumentKindRepository,
  IDocumentResponsibleRepositoryUnit,
  DocumentNumeratorRegistry,
  DocumentChargesInfoDTODomainMapper,
  DocumentApprovingsInfoDTOMapper,
  IEmployeeRepositoryUnit,
  DocumentFlowEmployeeInfoDTOMapper,
  Disposable,
  DocumentNumerator,
  StandardDocumentNumerator,
  SysUtils,
  Classes;

type

  TIncomingDocumentDTOMapper = class (TDocumentDTOMapper)

    protected

      FDocumentDTOMapper: TDocumentDTOMapper;
      FFreeDocumentDTOMapper: IDisposable;

      function CreateIncomingDocumentDTOInstance: TIncomingDocumentDTO; virtual;

      procedure RaiseExceptionIfDocumentIsNotIncoming(
        Document: TDocument
      );

      function GetDocumentIncomingNumberPartsSeparator(IncomingDocument: TIncomingDocument): String;
      
    public

      destructor Destroy; override;
      
      constructor Create(
        EmployeeRepository: IEmployeeRepository;
        DocumentKindRepository: IDocumentKindRepository;
        DocumentResponsibleRepository: IDocumentResponsibleRepository;
        DocumentNumeratorRegistry: IDocumentNumeratorRegistry;
        DocumentChargesInfoDTODomainMapper: TDocumentChargesInfoDTODomainMapper;
        DocumentApprovingsInfoDTOMapper: TDocumentApprovingsInfoDTOMapper;
        DocumentFlowEmployeeInfoDTOMapper: TDocumentFlowEmployeeInfoDTOMapper;
        DocumentDTOMapper: TDocumentDTOMapper
      );

      function MapDocumentDTOFrom(
        Document: TDocument;
        AccessingEmployee: TEmployee
        
      ): TDocumentDTO; override;

  end;
  
implementation

{ TIncomingDocumentDTOMapper }

constructor TIncomingDocumentDTOMapper.Create(
  EmployeeRepository: IEmployeeRepository;
  DocumentKindRepository: IDocumentKindRepository;
  DocumentResponsibleRepository: IDocumentResponsibleRepository;
  DocumentNumeratorRegistry: IDocumentNumeratorRegistry;
  DocumentChargesInfoDTODomainMapper: TDocumentChargesInfoDTODomainMapper;
  DocumentApprovingsInfoDTOMapper: TDocumentApprovingsInfoDTOMapper;
  DocumentFlowEmployeeInfoDTOMapper: TDocumentFlowEmployeeInfoDTOMapper;
  DocumentDTOMapper: TDocumentDTOMapper
);
begin

  inherited Create(
    EmployeeRepository,
    DocumentKindRepository,
    DocumentResponsibleRepository,
    DocumentNumeratorRegistry,
    DocumentChargesInfoDTODomainMapper,
    DocumentApprovingsInfoDTOMapper,
    DocumentFlowEmployeeInfoDTOMapper
  );

  FDocumentDTOMapper := DocumentDTOMapper;
  FFreeDocumentDTOMapper := FDocumentDTOMapper;
  
end;

function TIncomingDocumentDTOMapper.CreateIncomingDocumentDTOInstance: TIncomingDocumentDTO;
begin

  Result := TIncomingDocumentDTO.Create;

end;

destructor TIncomingDocumentDTOMapper.Destroy;
begin
  
  inherited;

end;

function TIncomingDocumentDTOMapper.
  GetDocumentIncomingNumberPartsSeparator(
    IncomingDocument: TIncomingDocument
  ): String;
var
    Receiver: TEmployee;
    DocumentNumerator: TDocumentNumerator;
begin

  Receiver := FEmployeeRepository.FindEmployeeById(IncomingDocument.ReceiverId);

  if not Assigned(Receiver) then begin

    Raise Exception.Create(
      'Во время формирования данных входящего документа ' +
      'не найдена информация о соответствующем получателе'
    );

  end;

  DocumentNumerator :=
    FDocumentNumeratorRegistry
      .GetDocumentNumeratorFor(
        IncomingDocument.ClassType,
        Receiver.DepartmentIdentity
      );

  if not Assigned(DocumentNumerator) then begin

    Raise Exception.Create(
      'Во время формирования данных входящего документа ' +
      'не найден разделитель частей входящего номера'
    );
    
  end;

  Result := DocumentNumerator.NumberConstantParts.Delimiter;
  
end;

function TIncomingDocumentDTOMapper.MapDocumentDTOFrom(
  Document: TDocument;
  AccessingEmployee: TEmployee
  
): TDocumentDTO;

var
    IncomingDocument: TIncomingDocument;

    IncomingDocumentDTO: TIncomingDocumentDTO;
    OriginalDocumentDTO: TDocumentDTO;
begin

  RaiseExceptionIfDocumentIsNotIncoming(Document);

  IncomingDocument := TIncomingDocument(Document);

  OriginalDocumentDTO :=
    FDocumentDTOMapper.MapDocumentDTOFrom(
      IncomingDocument.OriginalDocument,
      AccessingEmployee
    );

  IncomingDocumentDTO := CreateIncomingDocumentDTOInstance;

  IncomingDocumentDTO.OriginalDocumentDTO := OriginalDocumentDTO;
  IncomingDocumentDTO.IncomingNumber := IncomingDocument.IncomingNumber;
  IncomingDocumentDTO.ReceiptDate := IncomingDocument.ReceiptDate;
  IncomingDocumentDTO.IncomingNumberPartsSeparator :=
    GetDocumentIncomingNumberPartsSeparator(IncomingDocument);
  
end;

procedure TIncomingDocumentDTOMapper.RaiseExceptionIfDocumentIsNotIncoming(
  Document: TDocument);
begin

  if not (Document is TIncomingDocument) then begin

    raise Exception.Create(
      'Программная ошибка. Отображение ' +
      'не входящего документа на DTO'
    );
    
  end;

end;

end.
