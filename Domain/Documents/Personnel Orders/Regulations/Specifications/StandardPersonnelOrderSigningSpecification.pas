unit StandardPersonnelOrderSigningSpecification;

interface

uses

  StandardDocumentSigningSpecification,
  DocumentSigningSpecification,
  IDocumentUnit,
  Employee,
  Document,
  EmployeeIsSameAsOrReplacingForOthersSpecification,
  DomainException,
  PersonnelOrderControlService,
  PersonnelOrder,
  SysUtils;

type

  TStandardPersonnelOrderSigningSpecification =
    class (TStandardDocumentSigningSpecification)

      protected

        FPersonnelOrderControlService: IPersonnelOrderControlService;

        procedure RaiseExceptionIfDocumentIsNotPersonnelOrder(Document: IDocument);
        
      public

        constructor Create(
          EmployeeIsSameAsOrReplacingForOthersSpecification: IEmployeeIsSameAsOrReplacingForOthersSpecification;
          PersonnelOrderControlService: IPersonnelOrderControlService
        );
        
        function IsEmployeeAnyOfOnesCanMarkDocumentAsSigned(
          Employee: TEmployee;
          Document: IDocument
        ): Boolean; override;

    end;
    
implementation

{ TStandardPersonnelOrderSigningSpecification }

constructor TStandardPersonnelOrderSigningSpecification.Create(
  EmployeeIsSameAsOrReplacingForOthersSpecification: IEmployeeIsSameAsOrReplacingForOthersSpecification;
  PersonnelOrderControlService: IPersonnelOrderControlService
);
begin

  inherited Create(EmployeeIsSameAsOrReplacingForOthersSpecification);

  FPersonnelOrderControlService := PersonnelOrderControlService;
  
end;

function TStandardPersonnelOrderSigningSpecification
  .IsEmployeeAnyOfOnesCanMarkDocumentAsSigned(
    Employee: TEmployee;
    Document: IDocument
  ): Boolean;
begin

  RaiseExceptionIfDocumentIsNotPersonnelOrder(Document);

  Result :=
    FPersonnelOrderControlService.MayEmployeeControlPersonnelOrders(
      TPersonnelOrder(Document.Self).SubKindId, Employee
    );

end;

procedure TStandardPersonnelOrderSigningSpecification.RaiseExceptionIfDocumentIsNotPersonnelOrder(
  Document: IDocument);
begin

  if not (Document.Self is TPersonnelOrder) then begin

    raise TDocumentSigningSpecificationException.Create(
      'Программная ошибка. Во время работы спецификации ' +
      'подписания обнаружен документ, не являющийся кадровым приказом'
    );
    
  end;

end;

end.
