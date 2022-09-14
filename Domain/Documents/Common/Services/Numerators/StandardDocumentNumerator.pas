unit StandardDocumentNumerator;

interface

uses

  INumberGeneratorUnit,
  DocumentNumerator,
  Document,
  SysUtils,
  Classes;

type

  TDocumentNumberConstantParts = class

    private

      FPrefix: String;
      FPostfix: String;
      FDelimiter: String;

      public

        constructor Create; overload;
        constructor Create(
          const Prefix, Postfix, Delimiter: String
        ); overload;

      published

        property Prefix: String read FPrefix write FPrefix;
        property Postfix: String read FPostfix write FPostfix;
        property Delimiter: String read FDelimiter write FDelimiter;

  end;
  
  TDocumentNumerator = class (TInterfacedObject, IDocumentNumerator)

    protected

      FNumberConstantParts: TDocumentNumberConstantParts;
      FNumberGenerator: INumberGenerator;

      procedure SetNumberConstantParts(
        const Value: TDocumentNumberConstantParts
      );

      function GetPostfixAboutAutomaticallyGeneratedNumber: String; virtual;

      function InternalCreateNewDocumentNumber: String; virtual;

    public

      destructor Destroy; override;
      constructor Create(
        NumberConstantParts: TDocumentNumberConstantParts;
        NumberGenerator: INumberGenerator
      );

      function CreateNewDocumentNumber: String;
      procedure Reset;

      property NumberConstantParts: TDocumentNumberConstantParts
      read FNumberConstantParts write SetNumberConstantParts;

  end;
  
implementation


{ TDocumentNumerator }

constructor TDocumentNumerator.Create(
  NumberConstantParts: TDocumentNumberConstantParts;
  NumberGenerator: INumberGenerator
);
begin

  inherited Create;

  FNumberConstantParts := NumberConstantParts;
  FNumberGenerator := NumberGenerator;
  
end;

function TDocumentNumerator.CreateNewDocumentNumber: String;
begin

  try

    Result := InternalCreateNewDocumentNumber;

  except

    on e: Exception do begin

      if e is TCurrentNumberNotFoundException then
        raise TDocumentNumeratorException.Create(
          'Не удалось найти нумератор для документа. ' +
          'Обратитесь к администратору для создания ' +
          'нумератора'
        );
      
      raise;
      
    end;

  end;

end;

destructor TDocumentNumerator.Destroy;
begin

  FreeAndNil(FNumberConstantParts);
  inherited;

end;

function TDocumentNumerator.GetPostfixAboutAutomaticallyGeneratedNumber: String;
begin

  Result := '-Э';
  
end;

function TDocumentNumerator.InternalCreateNewDocumentNumber: String;
begin

  Result :=
    FNumberConstantParts.Prefix +
    FNumberConstantParts.Delimiter +
    IntToStr(FNumberGenerator.GetNextNumber) +
    FNumberConstantParts.Postfix +
    GetPostfixAboutAutomaticallyGeneratedNumber;

end;

procedure TDocumentNumerator.Reset;
begin

  FNumberGenerator.Reset;

end;

procedure TDocumentNumerator.SetNumberConstantParts(
  const Value: TDocumentNumberConstantParts);
begin

  FNumberConstantParts := Value;

end;

{ TDocumentNumberConstantParts }

constructor TDocumentNumberConstantParts.Create;
begin

  inherited;
  
end;

constructor TDocumentNumberConstantParts.Create(
  const Prefix, Postfix, Delimiter: String
);
begin

  inherited Create;

  FPrefix := Prefix;
  FPostfix := Postfix;
  FDelimiter := Delimiter;
  
end;

end.
