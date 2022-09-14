unit DocumentDTOMapper;

interface

uses

  Document,
  DocumentApprovings,
  DocumentCharges,
  DocumentSignings,
  DocumentFullInfoDTO,
  DocumentKindRepository,
  DocumentNumeratorRegistry,
  DocumentApprovingsInfoDTOMapper,
  DocumentChargesInfoDTODomainMapper,
  DocumentResponsibleInfoDTO,
  DepartmentInfoDTO,
  DocumentFlowEmployeeInfoDTOMapper,
  IDocumentResponsibleRepositoryUnit,
  IEmployeeRepositoryUnit,
  DocumentChargeInterface,
  Disposable,
  Employee,
  DocumentKind,
  SysUtils,
  Classes;

type

  TDocumentDTOMapper = class (TInterfacedObject, IDisposable)

    protected

      FEmployeeRepository: IEmployeeRepository;
      FDocumentKindRepository: IDocumentKindRepository;
      FDocumentResponsibleRepository: IDocumentResponsibleRepository;
      FDocumentNumeratorRegistry: IDocumentNumeratorRegistry;

      FDocumentChargesInfoDTODomainMapper: IDocumentChargesInfoDTODomainMapper;
      
      FDocumentApprovingsInfoDTOMapper: TDocumentApprovingsInfoDTOMapper;
      FFreeDocumentApprovingsInfoDTOMapper: IDisposable;
      
      FDocumentFlowEmployeeInfoDTOMapper: TDocumentFlowEmployeeInfoDTOMapper;
      FFreeDocumentFlowEmployeeInfoDTOMapper: IDisposable;
      
      function CreateDocumentDTOInstance: TDocumentDTO; virtual;

    protected

      function MapDocumentChargesInfoDTOFrom(
        DocumentCharges: IDocumentCharges;
        AccessingEmployee: TEmployee
      ): TDocumentChargesInfoDTO; virtual;
      
    protected

      function MapDocumentApprovingsInfoDTOFrom(
        Document: TDocument;
        AccessingEmployee: TEmployee
      ): TDocumentApprovingsInfoDTO; virtual;

    protected

      function MapDocumentSigningsInfoDTOFrom(
        DocumentSignings: TDocumentSignings;
        AccessingEmployee: TEmployee
      ): TDocumentSigningsInfoDTO; virtual;

      function MapDocumentSigningInfoDTOFrom(
        DocumentSigning: TDocumentSigning;
        AccessingEmployee: TEmployee
      ): TDocumentSigningInfoDTO; virtual;

    protected

      function GetDocumentResponsibleInfoDTOBy(
        const DocumentResponsibleId: Variant
      ): TDocumentResponsibleInfoDTO; virtual;
      
    public

      constructor Create(
        EmployeeRepository: IEmployeeRepository;
        DocumentKindRepository: IDocumentKindRepository;
        DocumentResponsibleRepository: IDocumentResponsibleRepository;
        DocumentNumeratorRegistry: IDocumentNumeratorRegistry;
        DocumentChargesInfoDTODomainMapper: IDocumentChargesInfoDTODomainMapper;
        DocumentApprovingsInfoDTOMapper: TDocumentApprovingsInfoDTOMapper;
        DocumentFlowEmployeeInfoDTOMapper: TDocumentFlowEmployeeInfoDTOMapper
      );
      
      function MapDocumentDTOFrom(
        Document: TDocument;
        AccessingEmployee: TEmployee
      ): TDocumentDTO; virtual;

  end;

implementation

uses

  DepartmentUnit,
  StandardDocumentNumerator,
  DocumentNumerator,
  IDomainObjectBaseUnit,
  Variants;
  
{ TDocumentDTOMapper }

constructor TDocumentDTOMapper.Create(
  EmployeeRepository: IEmployeeRepository;
  DocumentKindRepository: IDocumentKindRepository;
  DocumentResponsibleRepository: IDocumentResponsibleRepository;
  DocumentNumeratorRegistry: IDocumentNumeratorRegistry;
  DocumentChargesInfoDTODomainMapper: IDocumentChargesInfoDTODomainMapper;
  DocumentApprovingsInfoDTOMapper: TDocumentApprovingsInfoDTOMapper;
  DocumentFlowEmployeeInfoDTOMapper: TDocumentFlowEmployeeInfoDTOMapper
);
begin

  inherited Create;

  FEmployeeRepository := EmployeeRepository;
  FDocumentKindRepository := DocumentKindRepository;
  FDocumentResponsibleRepository := DocumentResponsibleRepository;
  FDocumentNumeratorRegistry := DocumentNumeratorRegistry;

  FDocumentChargesInfoDTODomainMapper := DocumentChargesInfoDTODomainMapper;

  FDocumentApprovingsInfoDTOMapper := DocumentApprovingsInfoDTOMapper;
  FFreeDocumentApprovingsInfoDTOMapper := FDocumentApprovingsInfoDTOMapper;
  
  FDocumentFlowEmployeeInfoDTOMapper := DocumentFlowEmployeeInfoDTOMapper;
  FFreeDocumentFlowEmployeeInfoDTOMapper := FDocumentFlowEmployeeInfoDTOMapper;
  
end;

function TDocumentDTOMapper.CreateDocumentDTOInstance: TDocumentDTO;
begin

  Result := TDocumentDTO.Create;

end;

function TDocumentDTOMapper.MapDocumentDTOFrom(
  Document: TDocument;
  AccessingEmployee: TEmployee
): TDocumentDTO;
var
    DocumentNumerator: TDocumentNumerator;
    FreeDocumentNumerator: IDocumentNumerator;

    DocumentKind: TDocumentKind;
    FreeDocumentKind: IDomainObjectBase;
begin

  Result := CreateDocumentDTOInstance;

  try
    
    Result.Id := Document.Identity;
    Result.Number := Document.Number;

    { refactor: изменить интерфейс реестра нумераторов, определять
      нужный номератор по одному параметру - объекту документа,
      тем самым скрыв логику поиска нумератор либо по виду док-а, либо
      по виду и подразделению
    }
    if
      not Document.Signings.IsEmpty
      and Assigned(FDocumentNumeratorRegistry)
    then begin

      DocumentNumerator :=
        FDocumentNumeratorRegistry.GetDocumentNumeratorFor(
          Document.ClassType, Document.Signings.First.Signer.DepartmentIdentity
        );

      FreeDocumentNumerator := DocumentNumerator;

      Result.SeparatorOfNumberParts := DocumentNumerator.NumberConstantParts.Delimiter;

    end;

    Result.Name := Document.Name;
    Result.Content := Document.Content;
    Result.CreationDate := Document.CreationDate;
    Result.DocumentDate := Document.DocumentDate;
    Result.Note := Document.Note;
    Result.KindId := Document.KindIdentity;

    if not VarIsNull(Result.KindId) then begin

      DocumentKind := FDocumentKindRepository.FindDocumentKindByIdentity(Result.KindId);

      FreeDocumentKind := DocumentKind;

      Result.Kind := DocumentKind.Name;

    end;

    Result.AuthorDTO :=
      FDocumentFlowEmployeeInfoDTOMapper.MapDocumentFlowEmployeeInfoDTOFrom(
        Document.Author
      );

    Result.ChargesInfoDTO := MapDocumentChargesInfoDTOFrom(Document.Charges, AccessingEmployee);
    Result.ApprovingsInfoDTO := MapDocumentApprovingsInfoDTOFrom(Document, AccessingEmployee);
    Result.SigningsInfoDTO := MapDocumentSigningsInfoDTOFrom(Document.Signings, AccessingEmployee);
    Result.ResponsibleInfoDTO := GetDocumentResponsibleInfoDTOBy(Document.ResponsibleId);

    Result.CurrentWorkCycleStageNumber := Document.CurrentWorkCycleStageNumber;
    Result.CurrentWorkCycleStageName := Document.CurrentWorkCycleStageName;
    Result.IsSelfRegistered := Document.IsSelfRegistered;
    
  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;

end;

function TDocumentDTOMapper.MapDocumentChargesInfoDTOFrom(
  DocumentCharges: IDocumentCharges;
  AccessingEmployee: TEmployee
): TDocumentChargesInfoDTO;
begin

  Result :=
    FDocumentChargesInfoDTODomainMapper
      .MapDocumentChargesInfoDTOFrom(
        TDocumentCharges(DocumentCharges.Self)
      );

end;

function TDocumentDTOMapper.MapDocumentApprovingsInfoDTOFrom(
  Document: TDocument;
  AccessingEmployee: TEmployee
): TDocumentApprovingsInfoDTO;
begin

  Result :=
    FDocumentApprovingsInfoDTOMapper.MapDocumentApprovingsInfoDTOFrom(
      Document, AccessingEmployee
    );

end;

function TDocumentDTOMapper.MapDocumentSigningsInfoDTOFrom(
  DocumentSignings: TDocumentSignings;
  AccessingEmployee: TEmployee
): TDocumentSigningsInfoDTO;
var
    DocumentSigning: TDocumentSigning;
begin

  Result := TDocumentSigningsInfoDTO.Create;

  if not Assigned(DocumentSignings) then Exit;

  try

    for DocumentSigning in DocumentSignings do
      Result.Add(MapDocumentSigningInfoDTOFrom(DocumentSigning, AccessingEmployee));
      
  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;

end;

function TDocumentDTOMapper.MapDocumentSigningInfoDTOFrom(
  DocumentSigning: TDocumentSigning;
  AccessingEmployee: TEmployee
): TDocumentSigningInfoDTO;
begin

  Result := TDocumentSigningInfoDTO.Create;

  try

    Result.Id := DocumentSigning.Identity;
    Result.SigningDate := DocumentSigning.SigningDate;
    
    Result.SignerInfoDTO :=
      FDocumentFlowEmployeeInfoDTOMapper.MapDocumentFlowEmployeeInfoDTOFrom(
        DocumentSigning.Signer
      );

    if Assigned(DocumentSigning.ActuallySignedEmployee) then begin

      Result.ActuallySignedEmployeeInfoDTO :=
        FDocumentFlowEmployeeInfoDTOMapper.MapDocumentFlowEmployeeInfoDTOFrom(
          DocumentSigning.ActuallySignedEmployee
        );

    end;

  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;

    end;

  end;

end;

function TDocumentDTOMapper.GetDocumentResponsibleInfoDTOBy(
  const DocumentResponsibleId: Variant
): TDocumentResponsibleInfoDTO;
var
    DocumentResponsible: TEmployee;
    FreeDocumentResponsible: IDomainObjectBase;

    DocumentResponsibleDepartment: TDepartment;
    FreeDocumentResponsibleDepartment: IDomainObjectBase;
begin

  DocumentResponsible :=
    FDocumentResponsibleRepository.FindDocumentResponsibleById(DocumentResponsibleId);

  FreeDocumentResponsible := DocumentResponsible;

  DocumentResponsibleDepartment :=
    FDocumentResponsibleRepository.FindDocumentResponsibleDepartmentById(
      DocumentResponsible.DepartmentIdentity
    );

  FreeDocumentResponsibleDepartment := DocumentResponsibleDepartment;

  Result := TDocumentResponsibleInfoDTO.Create;

  try

    Result.Id := DocumentResponsible.Identity;
    Result.Name := DocumentResponsible.FullName;
    Result.TelephoneNumber := DocumentResponsible.TelephoneNumber;

    Result.DepartmentInfoDTO :=
      TDepartmentInfoDTO.CreateFrom(
        DocumentResponsibleDepartment.Identity,
        DocumentResponsibleDepartment.Code,
        DocumentResponsibleDepartment.ShortName
      );
      
  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;

end;

end.
