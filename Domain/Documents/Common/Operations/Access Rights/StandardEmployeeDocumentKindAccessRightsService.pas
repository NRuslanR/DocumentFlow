unit StandardEmployeeDocumentKindAccessRightsService;

interface

uses

  EmployeeDocumentKindAccessRightsInfo,
  EmployeeDocumentKindAccessRightsService,
  PersonnelOrderCreatingAccessService,
  Employee,
  SysUtils,
  Classes;

type

  {
    refactor: разбить службу на несколько, каждая
    из которых будет ответственна за определения прав доступа
    к конкретному виду документов
  }
  TStandardEmployeeDocumentKindAccessRightsService =
    class (TInterfacedObject, IEmployeeDocumentKindAccessRightsService)

      protected

        FPersonnelOrderCreatingAccessService: IPersonnelOrderCreatingAccessService;
        
      protected

        procedure SetDocumentKindAccessRightsForEmployee(
          DocumentKind: TClass;
          Employee: TEmployee;
          AccessRightsInfo: TEmployeeDocumentKindAccessRightsInfo
        );
        
        procedure SetIncomingDocumentKindAccessRightsForEmployee(
          DocumentKind: TClass;
          Employee: TEmployee;
          AccessRightsInfo: TEmployeeDocumentKindAccessRightsInfo
        );

      protected

        procedure SetPersonnelOrderAccessRightsForEmployee(
          DocumentKind: TClass;
          Employee: TEmployee;
          AccessRightsInfo: TEmployeeDocumentKindAccessRightsInfo
        );
        
      public

        constructor Create(
          PersonnelOrderCreatingAccessService: IPersonnelOrderCreatingAccessService
        );

        function GetDocumentKindAccessRightsInfoForEmployee(
          DocumentKind: TClass;
          Employee: TEmployee
        ): TEmployeeDocumentKindAccessRightsInfo; virtual;

        procedure EnsureThatEmployeeCanCreateDocuments(
          DocumentKind: TClass;
          Employee: TEmployee
        );

        function EnsureThatEmployeeCanCreateDocumentsAndGetAllAccessRightsInfo(
          DocumentKind: TClass;
          Employee: TEmployee
        ): TEmployeeDocumentKindAccessRightsInfo; virtual;

        function EnsureThatEmployeeHasAnyDocumentKindAccessRightsAndGetAll(
          DocumentKind: TClass;
          Employee:  TEmployee
        ): TEmployeeDocumentKindAccessRightsInfo; virtual;

    end;

implementation

uses

  IDomainObjectBaseUnit,
  Document,
  IncomingDocument,
  PersonnelOrder;
  
{ TStandardEmployeeDocumentKindAccessRightsService }

constructor TStandardEmployeeDocumentKindAccessRightsService.Create(
  PersonnelOrderCreatingAccessService: IPersonnelOrderCreatingAccessService);
begin

  inherited Create;

  FPersonnelOrderCreatingAccessService := PersonnelOrderCreatingAccessService;
  
end;

procedure TStandardEmployeeDocumentKindAccessRightsService.EnsureThatEmployeeCanCreateDocuments(
  DocumentKind: TClass; Employee: TEmployee);
var
    Free: IDomainObjectBase;
begin

  Free :=
    EnsureThatEmployeeCanCreateDocumentsAndGetAllAccessRightsInfo(
      DocumentKind, Employee
    );

end;

function TStandardEmployeeDocumentKindAccessRightsService.
  EnsureThatEmployeeCanCreateDocumentsAndGetAllAccessRightsInfo(
    DocumentKind: TClass;
    Employee: TEmployee
  ): TEmployeeDocumentKindAccessRightsInfo;
begin

  Result :=
    GetDocumentKindAccessRightsInfoForEmployee(
      DocumentKind, Employee
    );

  if not Result.CanCreateDocuments then begin

    FreeAndNil(Result);
    
    raise TEmployeeDocumentKindAccessRightsServiceException.CreateFmt(
      'Сотрудник "%s" не может создавать ' +
      'документы этого вида',
      [
        Employee.FullName
      ]
    );

  end;

end;

function TStandardEmployeeDocumentKindAccessRightsService.
  EnsureThatEmployeeHasAnyDocumentKindAccessRightsAndGetAll(
    DocumentKind: TClass;
    Employee: TEmployee
  ): TEmployeeDocumentKindAccessRightsInfo;
begin

  Result :=
    GetDocumentKindAccessRightsInfoForEmployee(
      DocumentKind, Employee
    );

  if Result.AllAccessRightsAbsent then begin

    raise TEmployeeDocumentKindAccessRightsServiceException.CreateFmt(
      'Сотрудник "%s" не имеет полномочий ' +
      'для работы с документами этого вида',
      [Employee.FullName]
    );
      
  end;
  
end;

function TStandardEmployeeDocumentKindAccessRightsService.
  GetDocumentKindAccessRightsInfoForEmployee(
    DocumentKind: TClass;
    Employee: TEmployee
  ): TEmployeeDocumentKindAccessRightsInfo;
var DocumentClass: TDocumentClass;
begin

  DocumentClass := TDocumentClass(DocumentKind);

  Result := TEmployeeDocumentKindAccessRightsInfo.Create;

  try

    if DocumentKind.InheritsFrom(TIncomingDocument) then begin

      SetIncomingDocumentKindAccessRightsForEmployee(
        DocumentKind, Employee, Result
      );

    end

    else if DocumentKind.InheritsFrom(TPersonnelOrder) then begin

      SetPersonnelOrderAccessRightsForEmployee(DocumentKind, Employee, Result);
      
    end
         
    else begin

      SetDocumentKindAccessRightsForEmployee(DocumentKind, Employee, Result);
      
    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

procedure TStandardEmployeeDocumentKindAccessRightsService.
  SetDocumentKindAccessRightsForEmployee(
    DocumentKind: TClass;
    Employee: TEmployee;
    AccessRightsInfo: TEmployeeDocumentKindAccessRightsInfo
  );
begin

  AccessRightsInfo.CanViewDocuments := True;
  AccessRightsInfo.CanCreateDocuments := True;
  AccessRightsInfo.CanCreateRespondingDocuments := False;
  AccessRightsInfo.CanEditDocuments := True;
  AccessRightsInfo.CanRemoveDocuments := True;
  AccessRightsInfo.DocumentNumberPrefixPatternType := ppDigits;

  if Employee.IsSecretarySignerForTopLevelEmployee then
    AccessRightsInfo.CanMarkDocumentsAsSelfRegistered := True;

end;

procedure TStandardEmployeeDocumentKindAccessRightsService.
  SetIncomingDocumentKindAccessRightsForEmployee(
    DocumentKind: TClass;
    Employee: TEmployee;
    AccessRightsInfo: TEmployeeDocumentKindAccessRightsInfo
  );
begin

  AccessRightsInfo.CanViewDocuments := True;
  AccessRightsInfo.CanCreateDocuments := False;
  AccessRightsInfo.CanCreateRespondingDocuments := True;
  AccessRightsInfo.CanEditDocuments := False;
  AccessRightsInfo.CanRemoveDocuments := False;
  AccessRightsInfo.CanMarkDocumentsAsSelfRegistered := False;
  AccessRightsInfo.DocumentNumberPrefixPatternType := ppNone;
  
end;

procedure TStandardEmployeeDocumentKindAccessRightsService.
  SetPersonnelOrderAccessRightsForEmployee(
    DocumentKind: TClass;
    Employee: TEmployee;
    AccessRightsInfo: TEmployeeDocumentKindAccessRightsInfo
  );
var
    MayEmployeeCreatePersonnelOrders: Boolean;
begin

  MayEmployeeCreatePersonnelOrders :=
    FPersonnelOrderCreatingAccessService.MayEmployeeCreatePersonnelOrders(Employee);

  AccessRightsInfo.CanViewDocuments := True;

  AccessRightsInfo.CanCreateDocuments := MayEmployeeCreatePersonnelOrders;
  AccessRightsInfo.CanEditDocuments := MayEmployeeCreatePersonnelOrders;
  AccessRightsInfo.CanRemoveDocuments := MayEmployeeCreatePersonnelOrders;

  AccessRightsInfo.CanCreateRespondingDocuments := False;
  AccessRightsInfo.CanMarkDocumentsAsSelfRegistered := False;

  AccessRightsInfo.DocumentNumberPrefixPatternType := ppNone;

end;

end.
