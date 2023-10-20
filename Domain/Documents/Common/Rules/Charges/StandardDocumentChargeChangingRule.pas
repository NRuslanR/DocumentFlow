unit StandardDocumentChargeChangingRule;

interface

uses

  DocumentChargeChangingRule,
  DocumentChargeInterface,
  DocumentCharges,
  DomainException,
  EmployeeIsSameAsOrReplacingForOthersSpecification,
  Employee,
  Disposable,
  IDomainObjectBaseListUnit,
  Document,
  IDocumentUnit,
  SysUtils,
  Classes;

type

  { refactor: передавать options -
    какие поля редактируемые }
  TStandardDocumentChargeChangingRule =
    class (TInterfacedObject, IDocumentChargeChangingRule)

      private

        FEmployeeIsSameAsOrReplacingForOthersSpecification:
          IEmployeeIsSameAsOrReplacingForOthersSpecification;

      protected

        procedure RaiseExceptionIfDocumentIsAtNotAllowedWorkCycleStage(
          Document: IDocument
        );

        procedure RaiseExceptionIfDocumentChargeStateNotValid(
          DocumentCharge: IDocumentCharge
        );

        procedure RaiseExceptionIfEmployeeHasNotRightsForDocumentChargeChanging(
          Employee: TEmployee;
          Document: IDocument;
          DocumentCharge: IDocumentCharge;
          var FieldNames: TStrings
        );

      protected

        function IsDocumentAtAllowedWorkCycleStage(Document: IDocument): Boolean; virtual;
        function IsDocumentChargeStateValid(DocumentCharge: IDocumentCharge; var ErrorMessage: String): Boolean; virtual;

        function HasEmployeeRightsForDocumentChargeChanging(
          Employee: TEmployee;
          Document: IDocument;
          DocumentCharge: IDocumentCharge;
          var FieldNames: TStrings;
          var ErrorMessage: String
        ): Boolean; virtual;

      public

        constructor Create(
          EmployeeIsSameAsOrReplacingForOthersSpecification:
            IEmployeeIsSameAsOrReplacingForOthersSpecification
        );

        function EnsureEmployeeMayChangeDocumentCharge(
          Employee: TEmployee;
          Document: IDocument;
          DocumentCharge: IDocumentCharge
        ): TStrings; overload;
        
        procedure EnsureEmployeeMayChangeDocumentCharge(
          Employee: TEmployee;
          Document: IDocument;
          DocumentCharge: IDocumentCharge;
          FieldNames: array of Variant
        ); overload;

        function MayEmployeeChangeDocumentCharge(
          Employee: TEmployee;       
          Document: IDocument;
          DocumentCharge: IDocumentCharge;
          FieldNames: array of Variant
        ): Boolean;

    end;

implementation

uses

  ArrayFunctions;

{ TStandardDocumentChargeChangingRule }

constructor TStandardDocumentChargeChangingRule.Create(
  EmployeeIsSameAsOrReplacingForOthersSpecification:
    IEmployeeIsSameAsOrReplacingForOthersSpecification
);
begin

  inherited Create;

  FEmployeeIsSameAsOrReplacingForOthersSpecification :=
    EmployeeIsSameAsOrReplacingForOthersSpecification;
    
end;

function TStandardDocumentChargeChangingRule.MayEmployeeChangeDocumentCharge(
  Employee: TEmployee;
  Document: IDocument;
  DocumentCharge: IDocumentCharge;
  FieldNames: array of Variant
): Boolean;
begin

  try

    EnsureEmployeeMayChangeDocumentCharge(
      Employee, Document, DocumentCharge, FieldNames
    );

    Result := True;

  except

    on E: TDomainException do Result := False;

  end;

end;

procedure TStandardDocumentChargeChangingRule.EnsureEmployeeMayChangeDocumentCharge(
  Employee: TEmployee;
  Document: IDocument;
  DocumentCharge: IDocumentCharge;
  FieldNames: array of Variant
);
var
    AllowedFieldNames: TStrings;
begin

  AllowedFieldNames :=
    EnsureEmployeeMayChangeDocumentCharge(Employee, Document, DocumentCharge);

  if not AreValuesIncludedByArray(FieldNames, AllowedFieldNames) then begin

    Raise TDocumentChargeException.CreateFmt(
      'У сотрудника "%s" отсутствуют права для ' +
      'изменения поручения',
      [
        Employee.FullName
      ]
    );
    
  end;

end;

function TStandardDocumentChargeChangingRule.
  EnsureEmployeeMayChangeDocumentCharge(
    Employee: TEmployee;
    Document: IDocument;
    DocumentCharge: IDocumentCharge
  ): TStrings;
var
    FieldNames: TStrings;
begin

  RaiseExceptionIfDocumentIsAtNotAllowedWorkCycleStage(Document);

  RaiseExceptionIfDocumentChargeStateNotValid(DocumentCharge);

  RaiseExceptionIfEmployeeHasNotRightsForDocumentChargeChanging(
    Employee, Document, DocumentCharge, FieldNames
  );

  Result := FieldNames;

end;

procedure TStandardDocumentChargeChangingRule.
  RaiseExceptionIfDocumentIsAtNotAllowedWorkCycleStage(Document: IDocument);
begin

  if not IsDocumentAtAllowedWorkCycleStage(Document) then begin

    Raise TDocumentChargeException.Create(
      'Документ находится на стадии, недоступной ' +
      'для изменения поручения'
    );
    
  end;
  
end;

function TStandardDocumentChargeChangingRule.IsDocumentAtAllowedWorkCycleStage(
  Document: IDocument): Boolean;
begin

  Result :=
    not (Document.IsApproving or Document.IsPerforming or Document.IsPerformed);

end;

procedure TStandardDocumentChargeChangingRule.
  RaiseExceptionIfDocumentChargeStateNotValid(DocumentCharge: IDocumentCharge);
var
    ErrorMessage: String;
begin

  if not IsDocumentChargeStateValid(DocumentCharge, ErrorMessage) then begin

    Raise TDocumentChargeException.Create(ErrorMessage);
    
  end;

end;

function TStandardDocumentChargeChangingRule.IsDocumentChargeStateValid(
  DocumentCharge: IDocumentCharge;
  var ErrorMessage: String
): Boolean;
begin

  Result := not DocumentCharge.IsPerformed;

  if not Result then begin

    ErrorMessage :=
      Format(
        'Нельзя изменить поручение для ' +
        'сотрудника "%s", поскольку оно выполнено',
        [
          DocumentCharge.Performer.FullName
        ]
      );

  end;

end;

procedure TStandardDocumentChargeChangingRule.
  RaiseExceptionIfEmployeeHasNotRightsForDocumentChargeChanging(
    Employee: TEmployee;
    Document: IDocument;
    DocumentCharge: IDocumentCharge;
    var FieldNames: TStrings
  );
var
    ErrorMessage: String;
begin

  if
    not HasEmployeeRightsForDocumentChargeChanging(
      Employee, Document, DocumentCharge, FieldNames, ErrorMessage
    )
  then begin

    Raise TDocumentChargeException.Create(ErrorMessage);
    
  end;

end;

function TStandardDocumentChargeChangingRule.
  HasEmployeeRightsForDocumentChargeChanging(
    Employee: TEmployee;
    Document: IDocument;
    DocumentCharge: IDocumentCharge;
    var FieldNames: TStrings;
    var ErrorMessage: String
  ): Boolean;
var
    SpecificationResult: TEmployeeIsSameAsOrReplacingForOthersSpecificationResult;
    FreeSpecificationResult: IDisposable;

    Replaceables: TEmployees;
    FreeReplaceables: IDomainObjectBaseList;

    Charge: TDocumentCharge;
begin

  Replaceables := Document.FetchAllSigners;

  FreeReplaceables := Replaceables;

  Replaceables.Add(Document.Author);

  SpecificationResult :=
    FEmployeeIsSameAsOrReplacingForOthersSpecification
      .IsEmployeeSameAsOrReplacingForAnyOfEmployees(
        Employee, Replaceables
      );

  FreeSpecificationResult := SpecificationResult;

  Result := SpecificationResult.IsSatisfied;

  if Result then begin

    Charge := DocumentCharge.Self as TDocumentCharge;
    
    FieldNames := TStringList.Create;

    FieldNames.Add(Charge.ChargeTextPropName);
    FieldNames.Add(Charge.IsForAcquaitancePropName)

  end

  else begin

    FieldNames := nil;

    ErrorMessage :=
      Format(
        'У сотрудника "%s" отсутствуют права ' +
        'для изменения поручения'
        ,
        [
          Employee.FullName
        ]
      );

  end;

end;

end.
