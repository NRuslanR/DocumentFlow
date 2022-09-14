unit StandardDocumentChargeSheetChangingRule;

interface

uses

  StandardDocumentChargeSheetWorkingRule,
  IDocumentChargeSheetUnit,
  DocumentChargeSheet,
  DocumentChargeSheetChangingRule,
  DocumentChargeSheetWorkingRule,
  EmployeeIsSameAsOrDeputySpecification,
  DomainException,
  IDocumentUnit,
  Employee,
  SysUtils,
  Classes;

type

  TStandardDocumentChargeSheetChangingRule =
    class (
      TInterfacedObject,
      IDocumentChargeSheetChangingRule
    )

      protected

        FEmployeeIsSameAsOrDeputySpecification: IEmployeeIsSameAsOrDeputySpecification;

        procedure RaiseExceptionIfDocumentChargeSheetStateNotValid(
          Employee: TEmployee;
          DocumentChargeSheet: TDocumentChargeSheet
        );

        procedure RaiseExceptionIfEmployeeHasNotRightsForDocumentChargeSheetChanging(
          Employee: TEmployee;
          DocumentChargeSheet: TDocumentChargeSheet;
          var FieldNames: TStrings
        );

        procedure RaiseExceptionIfDocumentChargeSheetFieldNamesNotInAllowed(
          FieldNames: array of Variant;
          AllowedFieldNames: TStrings;
          const ErrorMessage: String
        );

        procedure RaiseExceptionIfDocumentStateIsNotValid(
          Employee: TEmployee;
          ChargeSheet: TDocumentChargeSheet;
          Document: IDocument
        );

      protected

        function IsDocumentChargeSheetStateValid(
          DocumentChargeSheet: TDocumentChargeSheet;
          var ErrorMessage: String
        ): Boolean; virtual;

        function HasEmployeeRightsForDocumentChargeSheetChanging(
          Employee: TEmployee;
          DocumentChargeSheet: TDocumentChargeSheet;
          var FieldNames: TStrings;
          var ErrorMessage: String
        ): Boolean; virtual;

      public

        constructor Create(
          EmployeeIsSameAsOrDeputySpecification: IEmployeeIsSameAsOrDeputySpecification
        );

        function GetAlloweableDocumentChargeSheetFieldNames(
          Employee: TEmployee;
          DocumentChargeSheet: IDocumentChargeSheet;
          Document: IDocument
        ): TStrings;

        function EnsureEmployeeMayChangeDocumentChargeSheet(
          Employee: TEmployee;
          DocumentChargeSheet: IDocumentChargeSheet;
          Document: IDocument
        ): TStrings; overload;
        
        procedure EnsureEmployeeMayChangeDocumentChargeSheet(
          Employee: TEmployee;
          DocumentChargeSheet: IDocumentChargeSheet;
          Document: IDocument;
          FieldNames: array of Variant
        ); overload;

        function MayEmployeeChangeDocumentChargeSheet(
          Employee: TEmployee;
          DocumentChargeSheet: IDocumentChargeSheet;
          Document: IDocument;
          FieldNames: array of Variant
        ): Boolean;
        
    end;

implementation

uses

  Variants,
  DocumentAcquaitanceSheet,
  ArrayFunctions,
  AuxDebugFunctionsUnit;
  
{ TStandardDocumentChargeSheetChangingRule }

constructor TStandardDocumentChargeSheetChangingRule.Create(
  EmployeeIsSameAsOrDeputySpecification: IEmployeeIsSameAsOrDeputySpecification);
begin

  inherited Create;

  FEmployeeIsSameAsOrDeputySpecification := EmployeeIsSameAsOrDeputySpecification;
  
end;

procedure TStandardDocumentChargeSheetChangingRule.
  EnsureEmployeeMayChangeDocumentChargeSheet(
    Employee: TEmployee;
    DocumentChargeSheet: IDocumentChargeSheet;
    Document: IDocument;
    FieldNames: array of Variant
  );
var
    ChargeSheet: TDocumentChargeSheet;
    AllowedFieldNames: TStrings;
begin

  AllowedFieldNames :=
    EnsureEmployeeMayChangeDocumentChargeSheet(
      Employee, DocumentChargeSheet, Document
    );

  RaiseExceptionIfDocumentChargeSheetFieldNamesNotInAllowed(
    FieldNames,
    AllowedFieldNames,
    Format(
      'У сотрудника "%s" недостаточно прав ' +
      'для редактирования поручения',
      [
        Employee.FullName
      ]
    )
  );
  
end;

function TStandardDocumentChargeSheetChangingRule.
  GetAlloweableDocumentChargeSheetFieldNames(
    Employee: TEmployee;
    DocumentChargeSheet: IDocumentChargeSheet;
    Document: IDocument
  ): TStrings;
begin

  try

    Result :=
      EnsureEmployeeMayChangeDocumentChargeSheet(
        Employee,
        DocumentChargeSheet,
        Document
      );

  except

    on E: TDocumentChargeSheetChangingRuleException do Result := nil;

  end;
  
end;

function TStandardDocumentChargeSheetChangingRule.EnsureEmployeeMayChangeDocumentChargeSheet(
  Employee: TEmployee;
  DocumentChargeSheet: IDocumentChargeSheet;
  Document: IDocument
): TStrings;
var
    ChargeSheet: TDocumentChargeSheet;
    FieldNames: TStrings;
begin

  ChargeSheet := DocumentChargeSheet.Self as TDocumentChargeSheet;

  RaiseExceptionIfDocumentStateIsNotValid(Employee, ChargeSheet, Document);

  RaiseExceptionIfDocumentChargeSheetStateNotValid(Employee, ChargeSheet);

  RaiseExceptionIfEmployeeHasNotRightsForDocumentChargeSheetChanging(
    Employee, ChargeSheet, FieldNames
  );

  Result := FieldNames;
  
end;

function TStandardDocumentChargeSheetChangingRule.
  MayEmployeeChangeDocumentChargeSheet(
    Employee: TEmployee;
    DocumentChargeSheet: IDocumentChargeSheet;
    Document: IDocument;
    FieldNames: array of Variant
  ): Boolean;
begin

  try

    EnsureEmployeeMayChangeDocumentChargeSheet(
      Employee,
      DocumentChargeSheet,
      Document,
      FieldNames
    );

    Result := True;

  except

    on E: TDocumentChargeSheetChangingRuleException do Result := False;

  end;

end;

function TStandardDocumentChargeSheetChangingRule.
  HasEmployeeRightsForDocumentChargeSheetChanging(
    Employee: TEmployee;
    DocumentChargeSheet: TDocumentChargeSheet;
    var FieldNames: TStrings;
    var ErrorMessage: String
  ): Boolean;
begin

  FieldNames := nil;
  Result := False;

  if not Assigned(DocumentChargeSheet.Issuer) then begin
  
    ErrorMessage :=
      Format(
        'Сотрудник "%s" не может ' +
        'вносить изменения в поручение, ' +
        'поскольку для данного поручения ' +
        'не определён его автор',
        [
          Employee.FullName
        ]
      );

    Exit;

  end;

  if not Assigned(DocumentChargeSheet.Performer) then begin
  
    ErrorMessage :=
      Format(
        'Сотрудник "%s" не может ' +
        'вносить изменения в поручение, ' +
        'поскольку для данного поручения ' +
        'не определён его исполнитель',
        [
          Employee.FullName
        ]
      );

    Exit;

  end;

  if
    FEmployeeIsSameAsOrDeputySpecification
      .IsEmployeeSameAsOrDeputyForOtherOrViceVersa(
        Employee,
        DocumentChargeSheet.Issuer
      )
    and not DocumentChargeSheet.IsHead
  then begin

    FieldNames := TStringList.Create;

    FieldNames.Add(DocumentChargeSheet.ChargeTextPropName);

    Result := True;
    
  end

  else if
    FEmployeeIsSameAsOrDeputySpecification.
      IsEmployeeSameAsOrDeputyForOtherOrViceVersa(
        Employee, DocumentChargeSheet.Performer
      )
  then begin

    FieldNames := TStringList.Create;

    FieldNames.Add(DocumentChargeSheet.PerformerResponsePropName);

    Result := True;
    
  end

  else begin

    ErrorMessage :=
      Format(
        'Сотрудник "%s" не может вносить ' +
        'изменения в поручение, выданное ' +
        'сотрудником "%s", поскольку ' +
        'не имеет достаточных прав',
        [
          Employee.FullName,
          DocumentChargeSheet.Issuer.FullName
        ]
      );
      
  end;

end;

procedure TStandardDocumentChargeSheetChangingRule.
  RaiseExceptionIfDocumentChargeSheetStateNotValid(
    Employee: TEmployee;
    DocumentChargeSheet: TDocumentChargeSheet
  );
var
    ErrorMessage: String;
begin

  if not IsDocumentChargeSheetStateValid(DocumentChargeSheet, ErrorMessage)
  then begin

    Raise TDocumentChargeSheetChangingRuleException.Create(ErrorMessage);

  end;

end;

procedure TStandardDocumentChargeSheetChangingRule.RaiseExceptionIfDocumentStateIsNotValid(
  Employee: TEmployee;
  ChargeSheet: TDocumentChargeSheet;
  Document: IDocument);
var
    Condition: Boolean;
begin

  if ChargeSheet.DocumentId <> Document.Identity then begin

    Raise TDocumentChargeSheetChangingRuleException.CreateFmt(
      'Поручение для сотрудника "%s" не относится к документу',
      [
        ChargeSheet.Performer.FullName
      ]
    );

  end;

  if not (ChargeSheet is TDocumentAcquaitanceSheet) and Document.IsPerformed
  then begin
  
    Raise TDocumentChargeSheetChangingRuleException.CreateFmt(
      'Поручение для сотрудника "%s" не может быть ' +
      'изменено, поскольку документ уже выполнен',
      [
        ChargeSheet.Performer.FullName
      ]
    );

  end;

end;

function TStandardDocumentChargeSheetChangingRule.
  IsDocumentChargeSheetStateValid(
    DocumentChargeSheet: TDocumentChargeSheet;
    var ErrorMessage: String
  ): Boolean;
begin

  Result := not DocumentChargeSheet.IsPerformed;

  if not Result then begin

    ErrorMessage :=
      Format(
        'Поручение для сотрудника "%s" ' +
        'уже выполнено',
        [
          DocumentChargeSheet.Performer.FullName
        ]
      );

  end;

end;

procedure TStandardDocumentChargeSheetChangingRule.
  RaiseExceptionIfEmployeeHasNotRightsForDocumentChargeSheetChanging(
    Employee: TEmployee;
    DocumentChargeSheet: TDocumentChargeSheet;
    var FieldNames: TStrings
  );
var
    ErrorMessage: String;
begin

  if
    not
    HasEmployeeRightsForDocumentChargeSheetChanging(
      Employee, DocumentChargeSheet, FieldNames, ErrorMessage
    )
  then begin

    FreeAndNil(FieldNames);
    
    Raise TDocumentChargeSheetChangingRuleException.Create(ErrorMessage);

  end;

end;

procedure TStandardDocumentChargeSheetChangingRule.
  RaiseExceptionIfDocumentChargeSheetFieldNamesNotInAllowed(
    FieldNames: array of Variant;
    AllowedFieldNames: TStrings;
    const ErrorMessage: String
  );
begin

  if not AreValuesIncludedByArray(FieldNames, AllowedFieldNames) then begin

    Raise TDocumentChargeSheetChangingRuleException.Create(ErrorMessage);

  end;

end;

end.
