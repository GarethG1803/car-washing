import { Entity, Column } from 'typeorm';
import { BaseEntity } from '../../common/base.entity';

export enum DiscountType {
  PERCENTAGE = 'percentage',
  FIXED = 'fixed',
}

@Entity('promotions')
export class Promotion extends BaseEntity {
  @Column()
  title: string;

  @Column({ type: 'text', nullable: true })
  description: string;

  @Column({ unique: true })
  code: string;

  @Column({ type: 'text', default: DiscountType.PERCENTAGE })
  discountType: DiscountType;

  @Column({ type: 'float' })
  discountValue: number;

  @Column({ type: 'float', nullable: true })
  minimumOrder: number;

  @Column({ type: 'float', nullable: true })
  maximumDiscount: number;

  @Column()
  startDate: Date;

  @Column()
  endDate: Date;

  @Column({ default: 0 })
  usageCount: number;

  @Column({ nullable: true })
  usageLimit: number;

  @Column({ default: true })
  isActive: boolean;

  @Column({ nullable: true })
  imageUrl: string;
}
