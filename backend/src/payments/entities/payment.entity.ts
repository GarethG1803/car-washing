import { Entity, Column, ManyToOne } from 'typeorm';
import { BaseEntity } from '../../common/base.entity';
import { User } from '../../users/entities/user.entity';

export enum PaymentMethod {
  CREDIT_CARD = 'credit_card',
  DEBIT_CARD = 'debit_card',
  BANK_TRANSFER = 'bank_transfer',
  E_WALLET = 'e_wallet',
  CASH = 'cash',
}

export enum PaymentStatus {
  PENDING = 'pending',
  COMPLETED = 'completed',
  FAILED = 'failed',
  REFUNDED = 'refunded',
}

@Entity('payments')
export class Payment extends BaseEntity {
  @ManyToOne(() => User, user => user.payments)
  user: User;

  @Column()
  userId: string;

  @Column({ nullable: true })
  bookingId: string;

  @Column({ type: 'float' })
  amount: number;

  @Column({ type: 'text', default: PaymentMethod.CREDIT_CARD })
  method: PaymentMethod;

  @Column({ type: 'text', default: PaymentStatus.PENDING })
  status: PaymentStatus;

  @Column({ nullable: true })
  transactionId: string;

  @Column({ nullable: true })
  description: string;

  // Card details (masked)
  @Column({ nullable: true })
  cardLast4: string;

  @Column({ nullable: true })
  cardBrand: string;
}
