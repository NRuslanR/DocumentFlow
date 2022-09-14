unit StandardDocumentDraftingRule;

interface

uses

  DocumentDraftingRule,
  DocumentResponsibleFinder,
  IDocumentUnit,
  DocumentDraftingRuleOptions,
  Disposable,
  DocumentSigningSpecification,
  SysUtils,
  Employee,
  Classes;

type

  TStandardDocumentDraftingRule =
    class (TInterfacedObject, IDocumentDraftingRule)

      protected

        FOptions: IDocumentDraftingRuleCompoundOptions;
        
      protected

        FDocumentResponsibleFinder: IDocumentResponsibleFinder;
        FDocumentSigningSpecification: IDocumentSigningSpecification;

      protected

        function IsDocumentMainFieldsCorrectlyWritten(
          Document: IDocument;
          Options: IDocumentDraftingRuleOptions;
          var FailMessage: String
        ): Boolean; virtual;

        function IsDocumentChargesAssigned(
          Document: IDocument;
          Options: IDocumentDraftingRuleOptions;
          var FailMessage: String
        ): Boolean; virtual;

        function IsDocumentResponsibleCorrect(
          Document: IDocument;
          Options: IDocumentDraftingRuleOptions;
          var FailMessage: String
        ): Boolean; virtual;

        function IsDocumentSignersAssigned(
          Document: IDocument;
          Options: IDocumentDraftingRuleOptions;
          var FailMessage: String
        ): Boolean; virtual;

      protected

        procedure RaiseNumberRequiringCheckExceptionIfEditingEmployeeIsNotAssigned(Document: IDocument);

      protected

        function IsResponsibleAssigned(Document: IDocument): Boolean;

        procedure EnsureThatDocumentDraftedCorrectly(
          Document: IDocument;
          Options: IDocumentDraftingRuleOptions
        ); overload; virtual;

      public

        constructor Create(
          DocumentResponsibleFinder: IDocumentResponsibleFinder;
          DocumentSigningSpecification: IDocumentSigningSpecification;
          Options: IDocumentDraftingRuleCompoundOptions
        );
        
        procedure EnsureThatDocumentDraftedCorrectly(
          Document: IDocument
        ); overload;

        procedure EnsureThatDocumentDraftedCorrectlyForSigning(
          Document: IDocument
        );

        procedure EnsureThatDocumentDraftedCorrectlyForApprovingSending(
          Document: IDocument
        );

      public

        function GetOptions: IDocumentDraftingRuleCompoundOptions;
        procedure SetOptions(const Value: IDocumentDraftingRuleCompoundOptions);

        property Options: IDocumentDraftingRuleCompoundOptions
        read GetOptions write SetOptions;

    end;

implementation

uses

  StrUtils, Variants;
  
{ TStandardDocumentCorrectlyWritingSpecification }

constructor TStandardDocumentDraftingRule.Create(
  DocumentResponsibleFinder: IDocumentResponsibleFinder;
  DocumentSigningSpecification: IDocumentSigningSpecification;
  Options: IDocumentDraftingRuleCompoundOptions
);
begin

  inherited Create;

  FDocumentResponsibleFinder := DocumentResponsibleFinder;
  FDocumentSigningSpecification := DocumentSigningSpecification;

  Self.Options := Options

end;

procedure TStandardDocumentDraftingRule.EnsureThatDocumentDraftedCorrectly(
  Document: IDocument);
begin

  EnsureThatDocumentDraftedCorrectly(Document, Options);
  
end;

procedure TStandardDocumentDraftingRule.EnsureThatDocumentDraftedCorrectlyForApprovingSending(
  Document: IDocument);
begin

  EnsureThatDocumentDraftedCorrectly(Document, Options.ApprovingSending);

end;

procedure TStandardDocumentDraftingRule.EnsureThatDocumentDraftedCorrectlyForSigning(
  Document: IDocument);
begin

  EnsureThatDocumentDraftedCorrectly(Document, Options.Signing);

end;

procedure TStandardDocumentDraftingRule.
  EnsureThatDocumentDraftedCorrectly(
    Document: IDocument;
    Options: IDocumentDraftingRuleOptions
  );
var
    IsMainFieldsCorrectlyWritten,
    IsChargesAssigned,
    IsResponsibleCorrect,
    IsSignersAssigned: Boolean;
    ExceptionMessage: String;
    ExceptionMessagePartArray: array [0..3] of String;
    I, ExceptionMessagePartNumber: Integer;
    OrderedExceptionMessagePart: String;
begin

  IsMainFieldsCorrectlyWritten :=
    IsDocumentMainFieldsCorrectlyWritten(
      Document, Options, ExceptionMessagePartArray[0]
    );

  if FOptions.ChargesAssigningRequired then begin

    IsChargesAssigned :=
      IsDocumentChargesAssigned(
        Document, Options, ExceptionMessagePartArray[1]
      );

  end

  else IsChargesAssigned := True;

  IsSignersAssigned :=
    IsDocumentSignersAssigned(
      Document, Options, ExceptionMessagePartArray[2]
    );

  if FOptions.ResponsibleAssigningRequired then begin

    IsResponsibleCorrect :=
      IsDocumentResponsibleCorrect(
        Document, Options, ExceptionMessagePartArray[3]
      );

  end

  else IsResponsibleCorrect := True;

  if
    IsMainFieldsCorrectlyWritten and
    IsChargesAssigned and
    IsResponsibleCorrect and
    IsSignersAssigned
  then Exit;

  ExceptionMessagePartNumber := 0;
  
  for I := Low(ExceptionMessagePartArray) to High(ExceptionMessagePartArray)
  do begin

    if ExceptionMessagePartArray[I] = '' then Continue;

    Inc(ExceptionMessagePartNumber);

    OrderedExceptionMessagePart :=
      IntToStr(ExceptionMessagePartNumber) + ') ' +
      ExceptionMessagePartArray[I];

    if ExceptionMessage = '' then
      ExceptionMessage := OrderedExceptionMessagePart

    else
      ExceptionMessage := ExceptionMessage + sLineBreak + OrderedExceptionMessagePart;


  end;

  raise TDocumentDraftingRuleException.Create(
    'Документ некорректно оформлен:' +
    sLineBreak +
    ExceptionMessage
  );

end;

function TStandardDocumentDraftingRule.GetOptions: IDocumentDraftingRuleCompoundOptions;
begin

  Result := FOptions;
  
end;

function TStandardDocumentDraftingRule.
  IsDocumentChargesAssigned(
    Document: IDocument;
    Options: IDocumentDraftingRuleOptions;
    var FailMessage: String
  ): Boolean;
begin

  Result := not Document.Charges.IsEmpty;

  if not Result then
    FailMessage := 'Не указаны получатели.';
  
end;

function TStandardDocumentDraftingRule.
  IsDocumentMainFieldsCorrectlyWritten(
    Document: IDocument;
    Options: IDocumentDraftingRuleOptions;
    var FailMessage: String
  ): Boolean;
begin

  if (Trim(Document.Number) = '') and Options.NumberAssigningRequired then begin
                                {
    RaiseNumberRequiringCheckExceptionIfEditingEmployeeIsNotAssigned(Document);

    if
      Document.IsSentToSigning
      or
      FDocumentSigningSpecification
        .IsEmployeeAnyOfDocumentSignersOrOnesCanMarkDocumentAsSigned(
          Document.EditingEmployee, Document
        )
    then } FailMessage := 'номер';

  end;

  if Trim(Document.Name) = '' then
    FailMessage := FailMessage + IfThen(FailMessage <> '', ', наименование', 'наименование');

  if Options.ContentAssigningRequired and (Trim(Document.Content) = '') then
    FailMessage := FailMessage + IfThen(FailMessage <> '', ', содержание', 'содержание');
  
  if FailMessage <> '' then begin

    FailMessage := 'Не указаны - ' + FailMessage;

    Result := False;

  end

  else Result := True;
    
end;

function TStandardDocumentDraftingRule.
  IsDocumentResponsibleCorrect(
    Document: IDocument;
    Options: IDocumentDraftingRuleOptions;
    var FailMessage: String
  ): Boolean;
var Responsible: TEmployee;
begin

  Result := IsResponsibleAssigned(Document);

  if Result then begin

    Responsible :=
      FDocumentResponsibleFinder.FindDocumentResponsibleById(
        Document.ResponsibleId
      );

    Result :=
      (Responsible.Email <> '')
      or (Responsible.TelephoneNumber <> '');

  end;

  if not Result then begin

    FailMessage :=
      'Не указан исполнитель или его ' +
      'контактные данные отсутствуют. ' +
      'Исполнитель должен иметь, ' +
      ' по крайней мере, электронный почтовой ' +
      'адрес или номер телефона.';

  end;

end;

function TStandardDocumentDraftingRule.
  IsDocumentSignersAssigned(
    Document: IDocument;
    Options: IDocumentDraftingRuleOptions;
    var FailMessage: String
  ): Boolean;
begin

  Result := not Document.Signings.IsEmpty;

  if not Result then
    FailMessage := 'Не указан подписант.'

end;

function TStandardDocumentDraftingRule.IsResponsibleAssigned(
  Document: IDocument): Boolean;
begin

  Result := not VarIsNull(Document.ResponsibleId);
  
end;

procedure TStandardDocumentDraftingRule.RaiseNumberRequiringCheckExceptionIfEditingEmployeeIsNotAssigned(
  Document: IDocument);
begin

  if not Assigned(Document.EditingEmployee) then begin

    Raise TDocumentDraftingRuleException.Create(
      'Программная ошибка. Не назначен редактирующий ' +
      'сотрудник для проверки необходимости ' +
      'назначения номера документу'
    );

  end;

end;

procedure TStandardDocumentDraftingRule.SetOptions(
  const Value: IDocumentDraftingRuleCompoundOptions);
begin

  FOptions := Value;

end;

end.
