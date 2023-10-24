unit DocumentChargeWorkingRules;

interface

uses

  DocumentChargeChangingRule,
  Disposable,
  SysUtils;

type

  TDocumentChargeWorkingRules = class (TInterfacedObject, IDisposable)

    protected

      FChangingRule: IDocumentChargeChangingRule;

    public

      constructor Create(ChangingRule: IDocumentChargeChangingRule);

      property ChangingRule: IDocumentChargeChangingRule
      read FChangingRule write FChangingRule;

  end;
  
implementation

{ TDocumentChargeWorkingRules }

constructor TDocumentChargeWorkingRules.Create(
  ChangingRule: IDocumentChargeChangingRule);
begin

  inherited Create;

  Self.ChangingRule := ChangingRule;
  
end;

end.
